using nithesh.riskmanagement as rm from '../db/schema';
//Annotate Risk Elements
annotate rm.Risks with {
    ID     @title : 'Risks';
    title  @title : 'Title';
    owner  @title : 'Owner';
    prio   @title : 'Priority';
    descr  @title : 'Description';
    bp     @title : 'Business Partner';
    miti   @title : 'Mitigation';
    impact @title : 'Impact';
}

//Annotate Miti Elements
annotate rm.Mitigations with {
    ID    @(
        UI.Hidden,
        Common : {Text : descr}
    );
    owner @title : 'Owner';
    descr @title : 'Description';
};

annotate rm.Risks with {
    miti @(Common : {
        //Show Text, not id for mitigation in the context of risks
        Text            : miti.descr,
        TextArrangement : #TextOnly,
        ValueList       : {
            Label          : 'Mitigations',
            CollectionPath : 'Mitigations',
            Parameters     : [
                {
                    $Type             : 'Common.ValueListParameterInOut',
                    LocalDataProperty : miti_ID,
                    ValueListProperty : 'ID'
                },
                {
                    $Type             : 'Common.ValueListParameterDisplayOnly',                    
                    ValueListProperty : 'descr'
                }
            ]
        }
    })
};

annotate rm.BusinessPartners with {
    BusinessPartner @(Common : {
        Text : FirstName,
        ValueList : {
            Label : 'Business Partners',
            CollectionPath : 'BusinessPartners',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : BusinessPartner,
                    ValueListProperty : 'BusinessPartner',
                },
                 {
                    $Type             : 'Common.ValueListParameterDisplayOnly',                    
                    ValueListProperty : 'LastName'
                },
                 {
                    $Type             : 'Common.ValueListParameterDisplayOnly',                    
                    ValueListProperty : 'FirstName'
                }
            ]
        },
    })
};


using from './risks/annotations';
using from './common';