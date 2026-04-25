browse
Browse resources



GET
/api/v1/substances
Get all substance records


GET
/api/v1/vocabularies
Get all vocabularies

text search
Search by name, code, or other text fields



GET
/api/v1/suggest?q=ibupro
Get search suggestions from partially typed word "ibupro"


GET
/api/v1/substances/search?q=ASPIRIN
Global search for word "ASPIRIN"


GET
/api/v1/substances/search?q=root_approvalID:R16CO5Y76E
Search Substance by approvlID, which in the default FDA-seeded system is equivalent to the UNII code.


GET
/api/v1/substances/search?q=root_names_name:OXYTOCIN
Search for "OXYTOCIN" inside of a name


GET
/api/v1/substances/search?q=OXYTOCIN%20AND%20root_codes_codeSystem:WIKIPEDIA
Substance search for "OXYTOCIN" within codes which also have codesystem containing "WIKIPEDIA"


GET
/api/v1/substances/search?q=root_names_name:"%5EOXYTOCIN%24"
Exact name Search for "OXYTOCIN"


GET
/api/v1/substances/search?q=OXYTO*
substance search starting with "OXYTO"


GET
/api/v1/substances/search?q="APT-101*"
substance search starting with "APT-101"


GET
/api/v1/substances/search?q=root_names_name:"*2-Dimethyl*"
substance search containing "2-Dimethyl"


GET
/api/v1/substances/search?q=ASPIRIN%20ESTER
Substance search with words "ESTER" or "ASPIRIN"


GET
/api/v1/substances/search?q=ASPIRIN%20AND%20ESTER
Substance search with words "ESTER" and "ASPIRIN"


GET
/api/v1/substances/search?q=*MAB&facet=Substance%20Class%2Fprotein
Substance search for words that end in "MAB" and are restricted to proteins.


GET
/api/v1/substances/search?q=*MAB&facet=Substance%20Class%2Fprotein&facet=ATC%20Level%201%2FRESPIRATORY%20SYSTEM
Substance search for words that end in "MAB" and are restricted to proteins with ATC level 1 code in "RESPRITORY SYSTEM".


GET
/api/v1/substances/@bulkQuery
Get queries from the query list id.


DELETE
/api/v1/substances/@bulkQuery
Delete queries from the query list id.


POST
/api/v1/substances/@bulkQuery
Save bulk queries in database.


GET
/api/v1/substances/bulkSearch
bulk search on saved query list.


DELETE
/api/v1/substances/@userList/currentUser
Delete the entire user saved list specified by list name.


DELETE
/api/v1/substances/@userList/otherUser
ADMIN ROLE ONLY! Delete the entire user saved list specified by user name and list name.

chemical search
Search by chemical structure



GET
/api/v1/substances/structureSearch?q=COCN
Substructure search for SMILES/SMARTS string "COCN" - Async


GET
/api/v1/substances/structureSearch?q=COCN&sync=true
Substructure search for SMILES/SMARTS string "COCN" - Sync


GET
/api/v1/substances/structureSearch?q=CCOC(N)=O&type=sim&cutoff=0.6
Searches for similar structures to SMILES "CCOC(N)=O"


GET
/api/v1/substances/structureSearch?q=CCOC(N)=O&type=exact
Searches substances for structure equivalent to SMILES string "CCOC(N)=O".


GET
/api/v1/substances/structureSearch?q=Cl&type=flex
Searches substances for disconnected moiety equivalent to SMILES string "Cl".

meta search
Search within facets, filters, and suggestion lists



GET
/api/v1/suggest/@fields
get suggest fields


GET
/api/v1/substances/search/@facets?q=ASPIRIN&field=Code+System
Search for "ASPIRIN" with "Code System" facet


GET
/api/v1/substances/search/@facets?q=ASPIRIN&field=Code+System&ffilter=W*
Search for "ASPIRIN" with "Code System" facet values start with "W"


GET
/api/v1/substances/search/@facets?q=ASPIRIN&field=Code+System&ffilter=count:%5B0%20TO%201%5D
Search for "ASPIRIN" with "Code System" facet count between 0 and 1

details
Get details of a record



GET
/api/v1/substances({id})
Get a substance by id


GET
/api/v1/substances({name})
Get a substance by name


GET
/api/v1/substances({id})/names
Get names for a substance


GET
/api/v1/substances({uuid})/codes
Get codes for a substance


GET
/api/v1/substances({id})/codes($0)
Get the first code object


GET
/api/v1/substances({id})/codes($0)/code
Get the first code object's code string


GET
/api/v1/substances({id})/names(type:of)
Get official names


GET
/api/v1/substances({id})/names!(name)
Get JSONArray of 'name' string


GET
/api/v1/substances({id})/names(type:cn)!(name)
Get JSONArray of common names


GET
/api/v1/substances({id})/names(type:cn)!(name)!limit(1)
Get JSONArray of first common name


GET
/api/v1/substances({id})/names(type:cn)!(name)!skip(1)!limit(1)
Get JSONArray of first common name, skipping first value


GET
/api/v1/substances({id})/names!sort(created)
Get JSONArray of names by creation date (ascending)


GET
/api/v1/substances({id})/names!revsort(created)
Get JSONArray of names by creation date (descending)


GET
/api/v1/substances({id})/names!(createdBy)!distinct()
JSONArray of users who created a name


GET
/api/v1/substances({id})/structure/molfile
Get molfile for a structure


GET
/api/v1/substances({id})/structure/$molfile
Get raw text for the molfile of a structure


GET
/api/v1/substances({id})/structure!$inchikey()
Get InChIKey for a structure


GET
/api/v1/substances({id})/names!count()
Get name count


GET
/api/v1/substances({id})/names!group(type)
Get map of names grouped by name types


GET
/api/v1/substances({id})/@hierarchy
Get substance relationship hierarchy

create and update
Create, update, validate and approve records



POST
/api/v1/substances
Create a substance record



PUT
/api/v1/substances
Update a substance record



PUT
/api/v1/substances/novalid
Update a substance record



POST
/api/v1/vocabularies/@validate
Validate CV fragment structure



POST
/api/v1/substances/@validate
validate a substance



GET
/api/v1/substances({uuid})/@approve
"approve" a substance to generate approval ID


user saved list
Create, retrieve, update, and delete user saved list



GET
/api/v1/substances/@userLists/currentUser
Get the names of all the user saved lists owned by current user.


GET
/api/v1/substances/@userLists/otherUser
ADMIN ROLE ONLY! Get all the names of user saved lists of owned by a specified user.


GET
/api/v1/substances/@userList/{list}
Get the list(specified in the path) content of current user.


GET
/api/v1/substances/@userList/{user}/{list}
ADMIN ROLE ONLY! Get the user saved list(specified in the path) content of the user(specified in the path).


POST
/api/v1/substances/@userList/keys
Create a user saved list with list of UUIDs of the substances in the body, separated by comma. For example, deb33005-e87e-4e7f-9704-d5b4c80d3023,79dbcc59-e887-40d1-a0e3-074379b755e4.


POST
/api/v1/substances/@userList/etag/{etagId}
Create a user saved list with etag with the specified etag id. For example, @userList/7c9f73c931335ca3?listName="myList".


PUT
/api/v1/substances/@userList/currentUser/etag/{etagId}
Add more substances to the user saved list using etag.


PUT
/api/v1/substances/@userList/currentUser
Update the user saved list by adding more substances to the list or remove substances from the list.


PUT
/api/v1/substances/@userList/otherUser
ADMIN ROLE ONLY! Update the user saved list by adding more substances to the list or remove substances from the list.


GET
/api/v1/substances/@userList/status/{id}
Get the status of a saving or updating user saved list process.

Administrative
User and data management, back-end tasks and info



GET
/api/v1/scheduledjobs
Fetch a list of scheduled jobs


GET
/api/v1/scheduledjobs({id})
Fetch a list of scheduled jobs


GET
/api/v1/health/info
Fetch server information


GET
/api/v1/users
Retreive all user information


GET
/api/v1/users({id})
Retreive user information


DELETE
/api/v1/users/{user}
Delete a user


POST
/api/v1/users/{user}
Add a user


PUT
/api/v1/users/{user}
Edit a user


POST
/api/v1/users/{user}/password
change a user's password


POST
/api/v1/profile/password
Change current user's password


POST
admin/load
import a data set


GET
/api/v1/jobs/{id}
query import status


GET
/api/v1/{search}/export/{etag}
Get export options


GET
/api/v1/{search}/export/{etag}/{format}?{filename}
initialize export


GET
/api/v1/{substances}/export/scrubber/@schema
JSON Schema for record scrubber


GET
/api/v1/{substances}/export/expander/@schema
JSON Schema for record expander


GET
/api/v1/{substances}/export/configs
List all available export configurations


GET
/api/v1/{substances}/export/config/{id}
export configuration detail


PUT
/api/v1/{substances}/export/config/{id}
Update an existing export configuration


DELETE
/api/v1/{substances}/export/config/{id}
Delete an existing export configuration


POST
/api/v1/{substances}/export/config
Create new export configuration


GET
/api/v1/profile/downloads
Get user's export info


GET
/api/v1/profile/downloads/{id}
Get export info

service info
Provide information about an individual service, provide GSRS Gateway-friendly paths to actuator endpoints. Note that service context is different from the entity context. The service is typically equal the value of 'application.name' in the service's configuration and in turn equal to the folder name in gsrs3-main-deployment where the service CI code lives.



GET
/service-info/api/v1/{context}/@configurationProperties
Get a service's properties.


GET
/service-info/api/v1/{context}/@logConfigurationProperties
Get a service's properties and print to the log. Printing to the log can be a more secure option.


GET
/service-info/api/v1/{context}/actuator/health
Access the SpringBoot actuator for the service {context}. Example 'substances' service context and 'health' actuator endpoint.


GET
/service-info/api/v1/{serviceContext}/@indexValueMakerConfigs
Get a list of index value maker configuration objects active for a given service.


GET
/service-info/api/v1/{serviceContext}/@entityProcessorConfigs
Get a list of entity processor configuration objects active for a given service.


GET
/service-info/api/v1/{serviceContext}/@validatorConfigs/{entityContext}
Get a list of validator configuration objects active for a given service and given entity

rebackup and reindex


GET
/api/v1/substances/@databaseIndexDiff
Get the difference between database and indexes


PUT
/api/v1/substances/@databaseIndexSync
Reindex substances records that are in database, but not in indexes


GET
/api/v1/substances/@databaseIndexSync({id})
Get the reindex job status.


GET
/api/v1/substances/({id})/@rebackup
Rebackup the record specified by id.


PUT
/api/v1/substances/@rebackup
Rebackup the records specified by the list of ids.


GET
/api/v1/substances/({id})/@rebackupAndReindex
Rebackup and reindex the record specified by id.


PUT
/api/v1/substances/@rebackupAndReindex
Rebackup the records specified by the list of ids.