#NHS Code4Health Dental App Challenge

##Introduction

At the NHS Open Source Open Day to be held in Newcastle on 26th November it was proposed to run an 'on-the-day' app hack to showcase the HANDI-HOPD Open Platform Demonstrator. 

A vote was held via the [NHS Open Source programme](http://www.technologystrategy.england.nhs.uk/pg/groups/99205/) and the winner was a proposal to create an app supporting the Community Dental Service team in Northumbria, monitoring the dental health of children as part of a Safeguarding Children initiative.

A number of software development teams have offered their assistance on the 26th but since time will be extremely short on the day, this site will make a number of documents and other resources avaiable as a gentle heads-up.

The scenario and related application may seem simple but actually captures some fairly complex data including SNOMED coded items, counts, ordinals and is aligned with the the [RCP/AoMRC outpatient clinical headings](https://www.rcplondon.ac.uk/sites/default/files/standards-for-the-clinical-structure-and-content-of-patient-records.pdf). 

One of the key challenges for the hack teams will be to persist the collected information to the HANDI-HOPD platform via the openEHR Ehrscape API. This API will be unfamiliar to most of the teams involved, though some have had limited experience of working with openEHR data.

We also hope to be able to demonstrate the vendor-neutral aspect of openEHR by saving and retrieving the document to several openEHR servers, each working on completely different technical stacks.


##The Dental App Challenge Scenario

Community dental services (CDS) provide dental care for people unable to access care from high street dentists. This includes vulnerable children. Dental decay is a common finding in cases of child neglect. Effective communication between community dentists and school nurses will help identify children who are suffering neglect.

Current problem: In Northumbria CDS we use paper based clinical records and to share dental information with school nurses about a vulnerable child requires a [letter] to be generated by the dentist, saved as PDF and sent via email. Last month 9.5 days of dentist's time was spent writing these letters. We also want incorporate aspects of the [Dental Health Risk score app (RAG)](https://github.com/openGPSoC/dental_RAG-score) that was built at a recent NHS Hackday.

###Scenario objectives

1. Populate the Patient Demographics via a FHIR-like Patient API provided by Neovahealth / Black Pear software
2. Create the Dental Assessment data entry form
3. Persist the completed Dental Assessment data entry form to the HANDI-HOPD platform (Ehrscape API)
4. Create a service which transforms the persisted document to a PDF for attachment to an email.
5. Re-persist the openEHR document to other openEHR vendor servers (OceanEHR, Code24, Cabolabs).

It is expected that most hack teams will concentrate on items 1,2,3.   
We have identified a team who are happy to concentrate on items 4 and 5.

###What has been pre-prepared
To ensure that the app challenge can progress rapidly, a small number of assets have been pre-prepared...

*   openEHR archetypes and 'Dental Assessment Final Report' template, defining the target dataset 'schema'
*   openEHR Dental Assessment Final Report' instance data examples matching the target dataset schema
*   A minimal Prototype Dental Assesment data entry web app

###The prototype Dental Assessment data entry web app
 A [simple prototype app](http://c4hdental-handihopd.rhcloud.com/) with [source code on GitHub.](https://github.com/handihealth/C4H_dental_challenge) has been provided to help clarify the clinical requirements and the RAG Risk score algorithm, but does not include any integration with demographics or Ehrscape APIs. Hack teams are, of course, welcome to create a very different UI. 

 The key challenge for hack teams is to map the data fields into a target openEHR JSON string (to be provided). That string is then passed to the Ehrscape API for persistence.

####Key openEHR datatypes
openEHR has a very rich set of allowable datatypes. A full defiinition is beyond the scope of this document but developers new to this field may find the follwoing notes helpful.

*  **'text'** allows the recording of simple,unformatted text. openEHR does not normally constrain the length of string.
 
*  **'codedText'** is a commonly used datatype in openEHR systems and is a sub-class of text. i.e where-ever text is specified codedText can be used instead. 
  
  Codes may be 'external' e.g. SNOMED CT or 'local', where they are defined within archetypes and have the form 'atxxxxx'.   

  A codedText element always includes the terminologyID, the code itself and the text of the coded concept (Rubric).  
  Where a codedText item is required, allowed value(s) are expressed in the form:  

	terminologyId::code::rubric
	
	e.g. local::at0007::Dental swelling
	
	     SNOMED-CT::123456::No pathology found

*  **'ordinal'** is a datatype which combines codedText with a score, expressed as an integer.  
   
   *  0: Green  `local::at0022::Green`    
   *  1: Amber  `local::at0023::Amber`   
   *  2: Red    `local::at0024::Red`
		 	    
*  **'count'** is a simple integer.  

*  **'dateTime'** records a date or date and time using the [ISO8061 format](http://www.w3.org/TR/NOTE-datetime).
 
###The Dental Assessment dataset 
The dataset for the Dental Assessment form is defined as an 'openEHR template'. This is assembled  from a number of open source component 'archetypes' e.g. 'Symptom', 'Physical Examination' etc. These are brought together into a 'template' and further constrained to fit the Dental Assessment use-case.

####'Assessed by' section
**Dentist name:** `datatype=text`  
**Clinic address:** `datatype=text`  
**Date assessed:** `datatype=date (Use ISO 8061 format e.g. 2005-10-18T00:00:00.000+02:00)`  

####Primary School section
**Primary school contact name (person):** `datatype=text`  
**Contact details phone, email etc:** `datatype=text`   
**Name of school:** `datatype=text`  

####History Section
**Dental pain symptom:** `datatype=codedText: "SNOMED-CT::102616008::Painful mouth" (only include code if Dental pain symptom is present).`

####Examination Findings Section
**Number of teeth with decay (0-32):** `datatype=count:0-32 (integer)`  

**Dental swelling:** `datatype=codedText`  
  
* Dental swelling present `local::at0005::Dental swelling present`   
* Dental swelling absent  `local::at0006::Dental swelling absent` 
	 
**Plaque control:**  `datatype=codedText`  

* Good plaque control `local:at00002::Good plaque control` 
* Poor plaque control `local::at0003::Poor plaque control`  
 
####Radiology Findings section
*Either*  

  **No problems detected:** `datatype=codedText: SNOMED-CT::23875004:No diagnostic abnormality`    

*or* 
   
  **Number of teeth with decay (0-32):** `datatype=count:0-32 (integer)`   
  **Teeth with abscess (0-32):**`datatype=count:0-32 (integer)`  
 
####Dental RAG Score section
For this application only the Caries (Tooth decay) aspect of the original RAG score is required.  

**Clinical Factors:** `datatype=codedText (internal code)`  

* Teeth with carious lesions `local::at0025::Teeth with carious lesions` 
* No teeth with carious lessions `local::at0026::No teeth with carious lesions`  

**Patient Factors:**  `datatype=codedText [0..*] (multiple internal codes)`  

 *  Symptoms `local::at0027::Symptoms`  
 *  Diet - Excess sugar / frequent sugar `local::at0028::Diet - Excess sugar / frequent sugar`   
 *  Unsatisfactory Plaque control `local::at0029::Unsatisfactory Plaque control`  
 *  Sibling experience `local::at0030::Sibling experience`  
 
**Risk Score:** `ordinal` 

The score (Green | Amber | Red) for each RAG section is captured as an ordinal i.e. a codedText with an associated integer. 

*  0 Green `local::at0022::Green`  
*  1 Amber `local::at0023::Amber`  
*  2 Red   `local::at0024::Red`  
 
####Treatment planned section
**Treatment planned :** `text [0..*]`  

####Follow-up arrangements section
**Follow-up arrangements:** `text [0..*]`  

####Summary section
**Follow-up arrangements:** `text [0..*]`  


##Technical objectives

###A. Retrieve Patient Demographics

Retreive First name, Last Name, Address, Date of Birth, NHS Number, Gender.

The API will follow the FHIR Patient resource very closely and is likely to be of the form:

    GET {{baseurl}}/patient/?identifer={{nhsNumber}} where nhsNumber=7430345

Two FHIR demographics servers are available

*  [BlackPear FHIRBall server](https://pyruscloud.blackpear.com/fhir/Patient?identifier=7430345)  
*  [NeovaHealth FHIR-like server](http://nhsdemo.openeobs.net/api/v1/patient?identifier=7430345) (needs Basic Authentication: login=fhir_api pwd=fhir_api))

This will return a FHIR JSON string aligned with the [FHIR Patient resource.](http://hl7-fhir.github.io/patient.html).

e.g. [FHIR JSON Patient Example](https://github.com/handihealth/C4H_dental_challenge/blob/master/technical/instances/fhir%20child%20female.json)

Note that these severs currently return slightly different formats. This is expected to be resolved as part of the App challenge, or possibly in advance.

###B. Develop Dental Assessment form 

Hack teams are free to develop the Dental Assessment data entry form in any way they choose, so long as the key requirements are met. We expect a number of community dental stakeholders to be on-hand to offer advice and feedback. The prime objective is to be able ot share the data collected in an interoperable format.

Tablet or desktop formats are probably more appropriate to this use-case than phone formats.

###C. Persist the Dental Assessment Form as openEHR via HANDI-HOPD Ehrscape

All openEHR data is persisted as a COMPOSITION class. openEHR data can be highly structured and potentially complex. To simplify the challenge of persisting openEHR data, examples of Dental Assessment 'target composition' data instanceshave been provided in different formats. HANDI-HOPD EhrScape will accept any of these formats and the data is in each example is persisted identically. Other openEHR servers such as OceanEHR, Code24 and Cabolabs currently only support the RAW XML format.

Once the data is assembled in the correct format, the actual service call is very simple requiring only the setting of simple paramters and headers.

**Example openEHR target Composition Documents**

[Structured JSON](https://github.com/handihealth/C4H_dental_challenge/blob/master/technical/instances/AoMRC%20Community%20Dental%20Assessment%20STRUCTURED.json)
[Flat JSON](https://github.com/handihealth/C4H_dental_challenge/blob/master/technical/instances/AoMRC%20Community%20Dental%20Assessment%20FLAT.json)
[Raw XML](https://github.com/handihealth/C4H_dental_challenge/blob/master/technical/instances/AoMRC%20Community%20Dental%20Assessment%20 RAW.xml)

A typical CURL to POST (persist) FLAT JSON is ..

		POST /rest/v1/composition?ehrId=7df3a7f8-18a4-4602-a7c6-d77db59a3d23&templateId=UK AoMRC Community Dental Final Assessment&committerName=c4h_Committer&format=FLAT HTTP/1.1
		Host: rest.ehrscape.com
		Content-Type: application/json
		Authorization: Basic YzRoX2RlbnRhbDpiYWJ5dGVldGgyMw==
		Cache-Control: no-cache
		{
		  "ctx/composer_name": "Rebecca Wassall",
		  "ctx/language": "en",
		  "ctx/territory": "GB",
		  "ctx/time": "2014-09-23T00:11:02.518+02:00",
			  "community_dental_final_assessment_letter/assessment_scales/dental_rag_score:0/caries_tooth_decay/caries_risk|code": "at0024",
			...	
 
###D. Create a web service to retrieve the stored openEHR composition,  transform to PDF

Once the openEHr composition is stored, a separate service should retrieve the document, transform it to a PDF with a format similar to the [example Dental Assessment Letters](https://github.com/handihealth/C4H_dental_challenge/tree/master/docs), then attach to an email.


###E. Re-persist the composition to other openEHR servers

Several openEHR server vendors are working to emulate the key aspects of the Marand Ehrscape API so that it should be possible to demonstrate that these can consume and retrieve properly formatted openEHR canonical XML data.

Appropriate APIs will be provided but these should match the [EhrScape composition APIs](https://www.ehrscape.com/api-explorer.html), other than having a different baseUrl. Only XML RAW format is supported.


#openEHR and HANDI-HOPD Ehrscape

The [HANDI-HOPD Ehrscape API](https://www.ehrscape.com/api-explorer.html), developed by Marand, provides a simple restful API which hides much of the complexity of the underlying openEHR server. In particular it accepts simpler, flatter forms of data, using defaults within the template schema to correctly populate the canonical openEHR data which is actually stored internally.

The FLAT JSON format is just a set of simple name/value pairs where te 'name' carries the path to each element. You do not need to parse this path.

e.g. If working with an internal codedText value in the FLAT JSON format,it is only necessary to provide the local code, as the terminologyId and Rubric being derived from the accompanying template.

    FLAT JSON
		 ... "community_dental_final_assessment_letter/assessment_scales/dental_rag_score:0/caries_tooth_decay/clinical_factors|code": "at0025", ...
		 
    STRUCTURED JSON
     ... "clinical_factors": [
       {
        "|code": "at0025",
        "|terminology": "local",
        "|value": "Teeth with carious lesions"
      }
      ]	...
			
		RAW XML
		... <ns2:value xsi:type="ns2:DV_CODED_TEXT">
		        <ns2:value>Teeth with carious lesions</ns2:value>
		            <ns2:defining_code>
			            <ns2:terminology_id>
			 	            <ns2:value>local</ns2:value>
			           </ns2:terminology_id>
			           <ns2:code_string>at0025</ns2:code_string>
		           </ns2:defining_code>
	         </ns2:value>
       </ns2:value> ...			 


###Handling specific datatypes

**text**

**codedText**

**ordinal**

**date**

**Multiple occurrence data**


### Reference model attributes

A number of key data points need to be populated in an openEHR composition, which may not be appraent from the archetypes or templates. Developers can largely use the example instance documents and APIs for guidance but these notes may give useful background. Links are given to a UML representation ofthe openEHR documentation.

    API attributes
		commiter
    committerId

    COMPOSITION attributes
		composer
    composerId

    starttime

    healthcare_facility

    OBSERVATION attributes
		
		/time

    ACTION attributes
		
		/time


The Ehrscape FLAT and STRUCTURED formats hide much of the complexity of these attributes, providing sensible defaults.
In particular the `ctx` header common to both JSON STRUCTURED and FLAT formats, considerably simplifies the composition header ...

    "ctx/composer_name": "Rebecca Wassall",
    "ctx/health_care_facility|id": "999999-345",
    "ctx/health_care_facility|name": "Northumbria Community NHS",
    "ctx/id_namespace": "NHS-UK",
    "ctx/id_scheme": "2.16.840.1.113883.2.1.4.3",
    "ctx/language": "en",
    "ctx/territory": "GB",
    "ctx/time": "2014-09-23T00:11:02.518+02:00",


###Key openEHR identifiers###

**subjectId/externalId**

The subjectId (sometimes called externalId) is a patient identifier which is known outwith the openEHR system e.g. a hospital identifier or NHS number.

**ehrId**

In an openEHR system, each patient has an ehr (a per-patient electronic health record) with a unique **ehrId** identifier (usually a guid). All references to openEHR patient data are via this ehrId. An API call `GET ehr/` is used to reference the ehrId from the provided subjectId/externalId.

Other subsequent calls to the openEHR system for that particular patient are via the ehrId.

**compositionId**

All openEHR data is committed as one or more compositions, which is then assigned a unique compositionId. If the composition is subsequently updated the root compositionId remain unchanged but its version number is incremented. All previous composition versions are retained.



##HANDI-HOPD Ehrscape primer

Getting Started
===============

This guide is designed to help you explore and learn about the HANDI-HOPD Ehrscape API.

Audience
--------

This tutorial is designed for people familiar with Javascript
programming concepts. The REST API is designed to be easily accessible
from any programming language – once you understand the basic concepts
of the API, you will be able to apply them in most programming
languages.

Pre-requisites
--------------

### Supporting libraries

To interact with the REST API, a client application needs to construct
HTTP requests. For making JSON based API calls and deal with the
returned data we are using jQuery javascript library. For more info see
[jQuery home page](http://jquery.com).

### Context variables

Throughout this guide we are using the following predefined variables
and functions to improve the readability of the code:

-   variable `baseUrl`: holds the base url of the REST service. To get
    to a specific REST service we’ll append it to the base url, i.e.:

<!-- -->

    var baseUrl = 'https://rest.ehrscape.com/rest/v1';
    var queryUrl = baseUrl + '/query';


### Ehrscape domains and EhrExplorer

Ehrscape is set up as a set of 'domains', each of which is populated with its own dummy patient data and openEHR templates.

Each Ehrscape domain has its own login and password. 

There are 2 methods of accessing the ehrscape API:

1. Set up a sessionID variable via the GET /session call. This returns a token that can be supplied in the headers of any subsequent API calls.

2. Create a Basic Authentication string and pass this to each API call.

The ehrscape Domain that is being used for the Dental App Challenge is 

    login: ch4_dental
    password: babyteeth23
		
    Basic Authentication: Basic YzRoX2RlbnRhbDpiYWJ5dGVldGgyMw==

#### Marand EhrExplorer

The Marand Ehr Explorer tool is primarily used to create openEHR queries which will not be used much in this challenge but it may be helpful in allowing you to examine the openEHR templates which define the App chalenge dataset.
 
1. Browse to [EHRExplorer](https://dev.ehrscape.com/explorer/)
2. Enter the name and password for the Code4Health Dental domain `login:c4h_dental pwd:babyteeth23`
3. Leave the domain field as `'ehrscape'`

In the navigation bar on the left you can double-click on the AoMRC Community Dental Assessment (composition) template, which will open the template in the bottom-right panel. Right-click on nodes for further details of the constaints applied.

e.g. If you navigate to **'Plaque Control'** and right-click you can examine the internal *'atcode'* constrtaints allowed for this element.

#### Ehrscape API browser

The Marand Ehr Explorer tool is primarily used to create openEHR queries which will not be used much in this challenge but it may be helpful in allowing you to examine the openEHR templates which define the App chalenge dataset.
 
1. Browse to [EHRScape API Explorer](https://dev.ehrscape.com/api-explorer.html)
2. Press the setting (*) button and set userName to `c4h_dental` and password to `babyteeth23` 
3. Any test calls in the API browser will now work against the Code4health Dental App challenge domain.


#### Using Postman to test API calls

The [Postman add-on](http://getpostman.com) is vey useful for testing API calls outside of an application context.
Postman collection and environment files for the app challenge are available on GitHub.


### Some basic openEHR/Ehrscape concepts

The HANDI-HOPD Ehrscape API consumes, retrieves and queries patient healthcare data using a standardised specification and querying format defined by the openEHR Foundation. openEHR is complex and can be difficult for novices to understand (even those with a strong technical background ). In essence it provides a way for clinicians 
-   **baseUrl:** variable `baseUrl`: holds the base url of the REST service. To get
    to a specific REST service we’ll append it to the base url, i.e.:

    var baseUrl = 'https://rest.ehrscape.com/rest/v1';
    var queryUrl = baseUrl + '/query';

-   **ehrId:** variable `ehrId`: holds our sample patient’s ehrId. In openEHR the ehrId is the internal identifier used ot identify all of the health records for a single patient

-   **compositions:** All openEHR data is persisted as a 'composition' which includes header information such as the author of the clinical record 'composer', dates and times etc. Every composition has a unique ID and can be updated, in case of error. The rpevious version is always retained.

-   **AQL:** Ehrscape supports the use of AQL (Archetype Query Language) which allows highly granlar querying of openEHR compositions, including corss-composition, cross ehr querying. AQL will not be used much in the App challenge but is 


Get a SessionId
---------------

-   function `getSessionId()`: is used to obtain a session (ehr session)
    used for authentication. In most applications this session is
    injected as part of the application context and would not be
    directly handled by javascript.
		As an alternative, all of the Ehrscape APIs can be be passed the Ehrscape domain username + password as a Basic authnatication sting, as part of the Ajax header

``` {.js}
function getSessionId() {
    var response = $.ajax({
        type: "POST",
        url: baseUrl + "/session?username=" + encodeURIComponent(username) +
                "&password=" + encodeURIComponent(password),
        async: false
    });
    return response.responseJSON.sessionId;
}
```

Find a patient's ehrId
---------------------------------------

Before you can access the patient's openEHR, you need to retreive the ehrId for that patient from their externalId, in this case their NHSNumber "7430345".

The following API call is used:

-   `GET /ehr`: stores a new composition (document) ([see details](https://dev.ehrscape.com/api-explorer.html?api=thinkehr&service=/ehr&operation=/composition&method=GET&inline=false))

``` {.js}
var queryParams = {
    subjectId: '7430345',
		subjectNamespace: 'uk.nhs.nhsnumber',
    headers: {
        "Ehr-Session": sessionId
};
$.ajax({
    url: baseUrl + "/ehr" + $.param(queryParams),
    type: 'GET',
    accept: 'application/json',
    success: function (res) {
        $("#header").html("Store composition");
        $("#result").html(res.meta.href);
    }
});
```
which, if successful, returns the ehrId along with an ehrStatus object:

		{
		    "meta": {
		        "href": "https://rest.ehrscape.com/rest/v1/ehr/7df3a7f8-18a4-4602-a7c6-d77db59a3d23"
		    },
		    "action": "RETRIEVE",
		    "ehrStatus": {
		        "subjectId": "7430345",
		        "subjectNamespace": "uk.nhs.nhsnumber",
		        "queryable": true,
		        "modifiable": true
		    },
		    "ehrId": "7df3a7f8-18a4-4602-a7c6-d77db59a3d23"
		}


Persist the Community Dental Assessment
---------------------------------------

This example shows how to save the completed Community Dental Assessment to Ehrscape, using the FLAT JSON format. If you prefer to work with the STRUCTURED format smple change the 'format' parameter. 

The following API call is used:

-   `POST /composition`: stores a new composition (document) ([see details](https://dev.ehrscape.com/api-explorer.html?api=thinkehr&service=/composition&operation=/composition&method=POST&inline=false))

``` {.js}

var compositionData = {
	 {
	   "ctx/composer_name": "Rebecca Wassall",
	   "ctx/health_care_facility|id": "999999-345",
	   "ctx/health_care_facility|name": "Northumbria Community NHS",
	   "ctx/id_namespace": "NHS-UK",
	   "ctx/id_scheme": "2.16.840.1.113883.2.1.4.3",
	   "ctx/language": "en",
	   "ctx/territory": "GB",
	   "ctx/time": "2014-09-23T00:11:02.518+02:00", "community_dental_final_assessment_letter/patient_demographics:0/relevant_contacts/formal_carer:0/primary_school_contact/person_name/contact_name": "Nurse Baw", "community_dental_final_assessment_letter/patient_demographics:0/relevant_contacts/formal_carer:0/primary_school_contact/telecom_details_uk:0/contact_telecoms": "Mobile 0775 343 46547", "community_dental_final_assessment_letter/patient_demographics:0/relevant_contacts/formal_carer:0/primary_school_contact/primary_school": "St Mungo Primary school",
     "community_dental_final_assessment_letter/outpatient_details/outpatient_administration:0/contact_type|code": "at0008",
		 ..........
};

var queryParams = {
    "ehrId": ehrId,
    templateId: 'UK AoMRC Community Dental Final Assessment',
    format: 'FLAT',
    committer: 'ch4_committer'
    headers: {
        "Ehr-Session": sessionId
};
$.ajax({
    url: baseUrl + "/composition?" + $.param(queryParams),
    type: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(compositionData),
    success: function (res) {
        $("#header").html("Store composition");
        $("#result").html(res.meta.href);
    }
});
```
which, if successful, returns the compositionID of the successfully commited composition:

    https://rest.ehrscape.com/rest/v1/composition/82b75afd-b874-406f-8305-bc83adcf68ad::c4h_dental::1


Update the Community Dental Assessment
--------------------------------------

This example shows how to update a previously completed Community Dental Assessment to Ehrscape, using the FLAT JSON format. If you prefer to work with the STRUCTURED format smple change the 'format' parameter.

The compositionId that is passed must be the **FULL** compositionId of the previous version commited, including the domain identifier and version number.


The following API call is used:

-   `PUT /composition`: stores a new composition (document) with measurements ([see details](https://dev.ehrscape.com/api-explorer.html?api=thinkehr&service=/composition&operation=/composition&method=PUT&inline=false))

``` {.js}

var compositionData = {
	 {
	   "ctx/composer_name": "Rebecca Wassall",
	   "ctx/health_care_facility|id": "999999-345",
	   "ctx/health_care_facility|name": "Northumbria Community NHS",
	   "ctx/id_namespace": "NHS-UK",
	   "ctx/id_scheme": "2.16.840.1.113883.2.1.4.3",
	   "ctx/language": "en",
	   "ctx/territory": "GB",
	   "ctx/time": "2014-09-23T00:11:02.518+02:00", "community_dental_final_assessment_letter/patient_demographics:0/relevant_contacts/formal_carer:0/primary_school_contact/person_name/contact_name": "Nurse Baw", "community_dental_final_assessment_letter/patient_demographics:0/relevant_contacts/formal_carer:0/primary_school_contact/telecom_details_uk:0/contact_telecoms": "Mobile 0775 343 46547", "community_dental_final_assessment_letter/patient_demographics:0/relevant_contacts/formal_carer:0/primary_school_contact/primary_school": "St Mungo Primary school",
     "community_dental_final_assessment_letter/outpatient_details/outpatient_administration:0/contact_type|code": "at0008",
		 ......
};

var queryParams = {
    templateId: 'UK AoMRC Community Dental Final Assessment',
    format: 'FLAT',
    committer: 'ch4_committer'
    headers: {
        "Ehr-Session": sessionId
};
$.ajax({
    url: baseUrl + "/composition/82b75afd-b874-406f-8305-bc83adcf68ad::c4h_dental::1" + $.param(queryParams),
    type: 'PUT',
    contentType: 'application/json',
    data: JSON.stringify(compositionData),
    success: function (res) {
        $("#header").html("Store composition");
        $("#result").html(res.meta.href);
    }
});
```
which, if successful, returns the compositionID of the successfully commited composition, with th e version identifier incremented. This is the compositionId that you will need to update the next time.

    https://rest.ehrscape.com/rest/v1/composition/82b75afd-b874-406f-8305-bc83adcf68ad::c4h_dental::2


Retrieve the most recent version of the Community Dental Assessment
-------------------------------------------------------------------

You can retrieve the most recent version of a persisted composition by simply passing the root of the compositionId, without the server name or version number.

 e.g.  `82b75afd-b874-406f-8305-bc83adcf68ad`

The following API call is used:

-   `GET /composition`: stores a new composition (document) with measurements ([see details](https://dev.ehrscape.com/api-explorer.html?api=thinkehr&service=/composition&operation=/composition&method=GET&inline=false))

``` {.js}

var queryParams = {
    format: 'FLAT',
    headers: {
        "Ehr-Session": sessionId
};
$.ajax({
    url: baseUrl + "/composition/82b75afd-b874-406f-8305-bc83adcf68ad" + $.param(queryParams),
    type: 'PUT',
    accept: 'application/json',
    success: function (res) {
        $("#header").html("Store composition");
        $("#result").html(res.meta.href);
    }
});
```


Delete the persisted Community Dental Assessment
--------------------------------------------------

The following API call is used:

-   `DELETE /composition`: stores a new composition (document) with measurements ([see details](https://dev.ehrscape.com/api-explorer.html?api=thinkehr&service=/composition&operation=/composition&method=DELETE&inline=false))

``` {.js}

var queryParams = {
    headers: {
        "Ehr-Session": sessionId
};
$.ajax({
    url: baseUrl + "/composition/82b75afd-b874-406f-8305-bc83adcf68ad::c4h_dental::1" + $.param(queryParams),
    type: 'PUT',
    accept: 'application/json',
    success: function (res) {
        $("#header").html("Store composition");
        $("#result").html(res.meta.href);
    }
});
```
