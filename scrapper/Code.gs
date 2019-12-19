function Game(url,gameASIN) {
  var price = UrlFetchApp.fetch(url+"/game/"+gameASIN).getContentText();
  return parseFloat(price);
}

function Amazon(url,amazonASIN) {  
  var price = UrlFetchApp.fetch(url+"/amazon/"+amazonASIN).getContentText();
  return parseFloat(price);
}

function MediaMarkt(url,mmASIN) {
  var price = UrlFetchApp.fetch(url+"/mediamarkt/"+mmASIN).getContentText();
  return parseFloat(price);
}

function Fnac(url,fnacASIN) {
  var price = UrlFetchApp.fetch(url+"/fnac/"+fnacASIN).getContentText();
  return parseFloat(price);
}

function lowest(actual, lowest) {
  if (lowest == 0){
    // empty cell
    return actual;
  }
  else if (actual < lowest){
    return actual;
  }
  else {
    return lowest;
  }
}

function currentTime() {
  var currentTime = new Date();
  return currentTime;
}

function waitOneHour() {
  Date.prototype.addHours= function(h){
    this.setHours(this.getHours()+h);
    return this;
  }
  return currentTime().addHours(1);
}

function isFloat(n){
    return Number(n) === n && n % 1 !== 0;
}

function sendEmail(actualPrice,alertPrice,shop,url,product,alert){
  var sheet = SpreadsheetApp.getActive().getActiveSheet();
  if (actualPrice <= alertPrice) {
    /*send email to me*/
    var recipient = 'my-email@gmail.com';
    var subject = "ALERTA BAJADA: " + product + " en " + shop;
    var body = "El producto " + product + " ha bajado a " + actualPrice + " en la tienda " + shop + ".\nPara comprarlo accede a su dirección en el siguiente enlace:\n" + url;
    GmailApp.sendEmail(recipient,subject,body);
    sheet.getRange("F".concat(alert+1)).setValue("");
  }
}

function core() {  
  var sheet = SpreadsheetApp.getActive().getActiveSheet();
  var data = sheet.getDataRange().getValues(); /* TODO: coger valores de la columna de urls, no el total pq el autocompletar de la última llena mucho mas de lo necesario el array*/
  var asinCol = 8;
  var lowestCol = 4;
  var url = "https://my-api-domain.com";
  
  for (var i = 1; i < data.length; i++) {
    var priceCell = "D".concat(i+1);
    var lowestCell = "E".concat(i+1);
    var asin = data[i][asinCol];
    var lowestPrice = data[i][lowestCol];
    var nextTry = data[i][13];
    
    if (data[i][7] == "game"){
      var actualPrice = Game(url,asin);
      sheet.getRange(priceCell).setValue(actualPrice);
      sheet.getRange(lowestCell).setValue(lowest(actualPrice,lowestPrice));
    }
    if ((data[i][7] == "amazon")&&(nextTry < currentTime())){
      var actualPrice = Amazon(url,asin);
      /*sheet.getRange("M".concat(i+1)).setValue(""); / * deletes cell */
      if (isFloat(actualPrice)){
        sheet.getRange(priceCell).setValue(actualPrice);
        sheet.getRange(lowestCell).setValue(lowest(actualPrice,lowestPrice));
      }
      /*else{ / * añadir espera por captcha * /  COMENTADO PORQUE NO QUIERO QUE TENGA EFECTO AHORA
        sheet.getRange("N".concat(i+1)).setValue(waitOneHour());
      }*/
    }    
    if (data[i][7] == "mediamarkt"){
      var actualPrice = MediaMarkt(url,asin);
      sheet.getRange(priceCell).setValue(actualPrice);
      sheet.getRange(lowestCell).setValue(lowest(actualPrice,lowestPrice));
    }
    if (data[i][7] == "fnac"){
      var actualPrice = Fnac(url,asin);
      sheet.getRange(priceCell).setValue(actualPrice);
      sheet.getRange(lowestCell).setValue(lowest(actualPrice,lowestPrice));
    }
    sendEmail(actualPrice,data[i][5],data[i][0],data[i][6],data[i][2],i);
  }
}