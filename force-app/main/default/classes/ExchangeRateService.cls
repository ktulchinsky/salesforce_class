public with sharing class ExchangeRateService {
    public static final String BASE_RATE = 'USD';

    private List<String> fromCurrencies = new List<String>();
    private Date conversionDate;

    @TestVisible private ExchangeRateService() {
        // for testing only
    }

    public ExchangeRateService(Date conversionDate, List<String> fromCurrencies) {
        this.conversionDate = conversionDate;
        this.fromCurrencies = fromCurrencies;

        if (this.conversionDate == null 
                || this.fromCurrencies == null
                || this.fromCurrencies.isEmpty()) {
            throw new ExchangeRateServiceException('Missing arguments');
        }
    }

    public List<Exchange_Rate__c> getFXRates() {
        String conversionDateString = String.valueOf(this.conversionDate);
        String fromCurrenciesString = String.join(this.fromCurrencies, ',');

        String endpoint = 'https://api.exchangeratesapi.io/' + conversionDateString +
                        '?base=' + BASE_RATE +
                        '&symbols=' + fromCurrenciesString;

        HttpRequest req = new HttpRequest();
        req.setTimeout(12000); //optional
        req.SetEndpoint(endpoint); //absolutely mandatory
        req.SetMethod('GET'); //absolutely mandatory

        Http http = new Http();
        HttpResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        String responseBody = res.getBody();

        if (statusCode > 200) {
            throw new ExchangeRateServiceException('API call failed with the following error:' + responseBody);
        }

        // deserialize my json string into an object
        ExchangeRateResponse fxRate = (ExchangeRateResponse)JSON.deserialize(responseBody, ExchangeRateResponse.class);
        return fxRate.getExchangeRates(this.conversionDate);

        //read about JSON object and difference between `deserialize`, `deserializeStrict`, and `deserializeUntyped`
        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_System_Json.htm
    }

    // public HttpResponse respond(HttpRequest request) {
    //     // Create a fake response
    //     HttpResponse res = new HttpResponse();
    //     res.setHeader('Content-Type', 'application/json');
    //     res.setBody('{"success":true,"timestamp":1555269846,"historical":true,"base":"EUR","date":"2019-04-14","rates":{"GBP":0.86366,"CAD":1.507216}}');
    //     res.setStatusCode(200);
    //     return res;
    // }

    public class ExchangeRateResponse {
        //create exchange rate object and serialize it
        public Map<String, Decimal> rates {get; set;}

        public List<Exchange_Rate__c> getExchangeRates(Date fxRateDate) {

            List<Exchange_Rate__c> exchangeRates = new List<Exchange_Rate__c>();

            for(String key : this.rates.keySet()){
               Exchange_Rate__c exchangeRate = new Exchange_Rate__c();
               exchangeRate.Currency__c = key;
               exchangeRate.Rate__c = this.rates.get(key);
               exchangeRate.Rate_Date__c = fxRateDate;
               
               exchangeRates.add(exchangeRate);
            }
            return exchangeRates;
        }
    }
    public class ExchangeRateServiceException extends Exception {}
}

// to invoke: 
// Date today = Date.today();
// List<String> currencies = new List<String>{'GBP', 'CAD'};
// ExchangeRateService fxService = new ExchangeRateService(today, currencies);
// String jsonResponse = fxService.getFXRates();
// System.debug(jsonResponse);