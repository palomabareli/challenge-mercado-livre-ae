from fastapi import FastAPI, Request
from fastapi_cache import FastAPICache
from fastapi_cache.backends.inmemory import InMemoryBackend
from fastapi.responses import JSONResponse
import httpx
import secrets
import json
from .config import APP_ID, REDIRECT_URI, CLIENT_SECRET, CODE, REFRESH_TOKEN, ACCESS_TOKEN, SITE_ID_MLA, LIMITED_SEARCH, PRODUCTS_LIST
from http import HTTPStatus
import asyncio

app = FastAPI()  

@app.on_event("startup")
async def startup():
    FastAPICache.init(InMemoryBackend())

#Requisição GET para verificar se a aplicação está funcionando
@app.get('/')
def read_root():
    return {'message': 'App woring!'}  

#Requisição POST para obter o access token
@app.post('/test') 
async def getAccessToken():
    token = secrets.token_bytes(16)
    grantype = "authorization_code"

    headers = {
        "accept": "application/json",
        "content-type": "application/x-www-form-urlencoded"
    }

    main_url = "https://api.mercadolibre.com/oauth/token"

    url_parameters = 'grant_type={}&client_id={}&client_secret={}&code={}&redirect_uri={}&code_verifier={}'.\
    format(grantype, APP_ID, CLIENT_SECRET, CODE, REDIRECT_URI, token)

    async with httpx.AsyncClient() as client:
        response = await client.post(main_url, headers=headers, data=url_parameters)

    response_json = response.json()
    return JSONResponse(response_json)  

#Requisição POST para obter o refresh token
@app.post('/getAccessToken') 
async def getAccessToken():
    token = secrets.token_bytes(16)
    grantype = "refresh_token"

    headers = {
        "accept": "application/json",
        "content-type": "application/x-www-form-urlencoded"
    }

    main_url = "https://api.mercadolibre.com/oauth/token"

    url_parameters = 'grant_type={}&client_id={}&client_secret={}&refresh_token={}'.\
    format(grantype, APP_ID, CLIENT_SECRET, REFRESH_TOKEN)

    async with httpx.AsyncClient() as client:
        response = await client.post(main_url, headers=headers, data=url_parameters)

    response_json = response.json()
    return JSONResponse(response_json)  

#Requisção GET para obter a lista de itens de 3 produtos: "chromecast", "googlehome", "appletv
#Para cada produto, são retornados 50 itens, e estes itens são armazenados em cache.
@app.get('/getListItens')
async def getListItens():
    all_portable_device_itens = []
    #https://api.mercadolibre.com/sites/$SITE_ID/search?q=Motorola%20G6
    url_principal = "https://api.mercadolibre.com/sites/{}/search?".format(SITE_ID_MLA)

    headers = {
        "Authorization": "Bearer {}".format(ACCESS_TOKEN)
    }

    async def fetch_product(product):
        url_dados = 'q={}&limit={}'.format(product, LIMITED_SEARCH)
        async with httpx.AsyncClient() as client:
            resposta_json = await client.get(url_principal + url_dados, headers=headers)
            if resposta_json.status_code == HTTPStatus.OK:
                return resposta_json.json().get("results", []) 
            return []   

    tasks = [fetch_product(product) for product in PRODUCTS_LIST]
    all_result = await asyncio.gather(*tasks)

    for result in all_result:
        all_portable_device_itens.extend([item.get("id") for item in result])
    #all_portable_device_itens.append(all_result)

    backend = FastAPICache.get_backend()
    await backend.set("all_portable_device_itens", all_portable_device_itens, expire=60*60*24)

    #with open('all_portable_device_itens.json', 'w') as file:
    #    json.dump(all_portable_device_itens, file, indent=4)

    return {'message': 'Successfully obtained list of itens'} 

#Requisição GET para obter os detalhes de cada item armazenado em cache.
#Para cara id de item que esta em cache é feita uma requisição para obter os detalhes do item.
#PROBLEMA: A API não retorna os detalhes do item (segui as orientações de https://developers.mercadolivre.com.br/pt_br/itens-e-buscas)
@app.get('/getCachedListIdItens')
async def getCachedListIdItens():
    backend = FastAPICache.get_backend()
    cached_portable_device_itens = await backend.get("all_portable_device_itens")

    #https://api.mercadolibre.com/items/{Item_Id} 
    url_principal = "https://api.mercadolibre.com/items/"
    #url_principal = "https://api.mercadolibre.com/items?"

    if not cached_portable_device_itens:
        return {'message': 'Error: No cached data available'}
    
    detailed_items = []
    
    for id_item in cached_portable_device_itens:
        async with httpx.AsyncClient() as client:
            #url_dados = 'id={}'.format(id_item)
            url_dados = '{}'.format(id_item)
            resposta = await client.get(url_principal+url_dados)

            if resposta.status_code == HTTPStatus.OK:
                detailed_items.append(resposta.json())

    #with open('detailed_items.json', 'w') as file:
    #    json.dump(detailed_items, file, indent=4)

    #return JSONResponse(cached_portable_device_itens)
    return {'message': 'Cached data retrieved and detailed items saved successfully'}


