import re
from bs4 import BeautifulSoup
import sys
import warnings
from requests_html import HTMLSession
import headers

def amazon(asin):
    #declare a session object
    session = HTMLSession()

    #ignore warnings
    if not sys.warnoptions:
        warnings.simplefilter("ignore")

    #declare the header.
    req = {
            'User-Agent': headers.agent()
        }
    amazon_url="https://www.amazon.es/dp/"+asin #The general structure of a url
    response = session.get(amazon_url, headers=req, verify=False) #get the response
    html = response.text
    soup = BeautifulSoup(html, 'html.parser')
    span = soup.find(id="priceblock_ourprice")
    eur = re.compile('\w+,\w+')
    x = eur.findall(str(span))
    if x == []: # for captcha block, return 0.00
        return "captcha"
    for price in x:
        return price.replace(",",".")

def game(asin):
    session = HTMLSession()

    if not sys.warnoptions:
        warnings.simplefilter("ignore")

    req = {
        'User-Agent': headers.agent()
    }
    game_url = "https://www.game.es/" + asin
    response = session.get(game_url, headers=req, verify=False)  # get the response
    html = response.text

    soup = BeautifulSoup(html, 'html.parser')

    #si el juego tiene precio, en la info pone puntos
    #si esta en reserva no
    span = soup.find("span", {"class": "buy--info"})
    respan = re.compile('Puntos')
    x = respan.findall(str(span))
    if(x): #no esta en reserva
        div = soup.find("div", {"class": "buy--price"})
        reint = re.compile('\d+')
        redec = re.compile('\'\d+')
        x = reint.findall(str(div))
        y = redec.findall(str(div))
        price = x[0]+y[0]
        return price.replace("'", ".")
    else: #si esta en reserva
        reprice = re.compile('\d+,\d+')
        price = reprice.findall(str(span))
        return price[0].replace(",",".")

def fnac(asin):
    session = HTMLSession()

    if not sys.warnoptions:
        warnings.simplefilter("ignore")

    req = {
        'User-Agent': headers.agent_others()
    }
    fnac_url = "https://www.fnac.es/" + asin
    response = session.get(fnac_url, headers=req, verify=False)
    html = response.text

    soup = BeautifulSoup(html, 'html.parser')
    span = soup.find("span", {"class":"f-productOffers-tabLabel--price"}) # Precio Fnac XX.XX
    disc = 0
    if(not span):
        span = soup.find("span", {"class":"f-priceBox-price f-priceBox-price--reco checked"}) #Texto grande, no recoge descuento
        disc = 0.05
    reint = re.compile('\d\d')
    redec = re.compile('\d\d')
    x = reint.findall(str(span))
    y = redec.findall(str(span))
    if x == y:
        price = x[0]+"."+y[1]
    else:
        price = x[0]+"."+y[0]
    if disc > 0: # Si existe el descuento, se lo aplico manualmente
        price = float(price)-(float(price)*disc)
        return ("%.2f" % price)
    else:
        return price

def mediamarkt(asin):
    session = HTMLSession()

    if not sys.warnoptions:
        warnings.simplefilter("ignore")

    req = {
        'User-Agent': headers.agent_others()
    }
    mm_url = "https://www.mediamarkt.es/es/product/" + asin
    response = session.get(mm_url, headers=req, verify=False)
    html = response.text

    soup = BeautifulSoup(html, 'html.parser')
    meta = soup.find("meta",{"itemprop":"price"})
    reprice = re.compile('[\d+|\d+.\d+]')
    price = reprice.findall(str(meta))
    x = ""
    for char in price:
        x += char
    return x



'''
print(amazon("B076VNR2C4"))
print(game("151667"))
print(game("151795"))
print(fnac("a3661696"))
print(mediamarkt("_tv-led-55-samsung-ue55nu7175-4k-uhd-smart-tv-hdr-10-uhd-dimming-dise%C3%B1o-slim-1437058.html"))
print(mediamarkt("_han-solo-una-historia-de-star-wars-blu-ray-1418304.html"))
print(fnac("a3518532"))
print(amazon("B01M9COSMD"))
print(amazon("B076VNR2C4"))
print(game("151510"))



print(fnac("a6757451"))
'''
