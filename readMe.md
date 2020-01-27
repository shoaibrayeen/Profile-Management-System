## Profile Management System
### OVERVIEW
Profiles are user accounts(seller/buyers in context of E commerce / Any selling buying company etc) which are created to save information regarding users to server them better in a system.
Generally it compromised with APIs to get/create/update profiles of users and a panel to view/search/edit profiles by admins.

### REQUIREMENT
- There should be a service which comprises of Internal panel and APIs to handle create/update and show of profiles.
Design profiles fields with your imagination(what you think is relevant for this projects Example, name, email, phone_number, profile_type(Broker/Owner/buyer) ,
status(account - Active/inactive) etc.)

```
APIs :
GET :  get-profile
Input - JSON { profile_id : Integer }
Output - JSON { profile-details :  example id, name, email, status }

POST : signup
Input : JSON { profile details like name, email, phone_number, password }
Output - JSON { profile_id : Interger, message - String}

POST : signin
Input : JSON { email/phone : abc@gmail.com, password : xyz}
Output : JSON { profile-details(basic) and success message}
```
- A panel which has features creating/showing/searching/editing profiles. This panel will require login(admin/password) to use these features.
- Admins can be created manually via console or rails form can be used to create them. They will be separate from profiles.
Daily report of no. of profiles created(Need to be done asynchronously to give the response instantly)

- Searching of profiles should be based on email/phone_number/name. It should be served by Elasticsearch.

### Additional
- When above mentioned task is done then need to create profile hierarchy. The system should support 2 vertical level of hierarchy( parent->children→grandchildren)
and maximum 4 children at each level only. Don't consider cases like same profile_type of different profile_types.
```
TECH Specifications
Language : Ruby
Framework : Rails
Database : Postgres
Caching/Token store : Redis
Background Jobs/Async Processing : Sidekiq





EVALUATION CRITERIA

Completeness( Basics - 45, Additional  - 15) - 60
Code quality(Code reuse, Variables, Structure, Documentation, Best practices) - 20
Schema(Normal Form, Indexes, Associations) - 20

Duration : 2 week(Starting 20th Jan, 2020)
Mid Evaluation by Mentors : 27th Jan, 2020
Final Evaluation : 3rd Feb, 2020
```
