//Imports
const cds = require('@sap/cds');

/**
 * Implementation for Risk Management service defined in ./risk-service.cds
 */
module.exports = cds.service.impl(async function () {
    //Define constants for the Risks and BusinessPartners entities from the risk-services.cds files
    const { Risks, BusinessPartners } = this.entities;

    this.after('READ', Risks, (data) => {
        const risks = Array.isArray(data) ? data : [data];
        risks.forEach(risk => {
            if (risk.impact >= 100000) {
                risk.criticality = 1;
            } else {
                risk.criticality = 2;
            }
        });
    });


    //Connect to Remote Service
    const BPsrv = await cds.connect.to('API_BUSINESS_PARTNER');
    /**
     * Event handler for read events on the BusinessParnters entity.
     * Each request to the API Business Hub requires the apikey in the header. 
     */
    this.on("READ", BusinessPartners, async (req) => {
        //The API Sandbox returns alot of business partners with empty names.
        //We dont want them in our application
        req.query.where("LastName <> '' and FirstName <> '' ");

        return await BPsrv.transaction(req).send({
            query: req.query,
            headers: {
                apikey: process.env.apikey,
            },
        });
    });

    /**
     * Instead of carrying out the expand, issue a separate request for each business partner 
     * This code could be optimized, instead of having n requests for n business partners,
     */

    try {
        const res = await next();
        await Promise.all(
            res.map(async (risk) => {
                const bp = await BPsrv.transaction(req).send({
                    query: SELECT.one(this.entities.BusinessPartners)
                        .where({ BusinessPartners: risk.bp_BusinessPartner })
                        .columns(["BusinessPartner", "LastName", "FirstName"]),
                     headers: {
                        apikey: process.env.apikey,
                    },
                })
                risk.bp = bp;
            })
        );
    } catch (error) {
        console.log(error);
        
    }

});

