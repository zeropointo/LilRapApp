
# LilRapApp: SOLID & Test Driven

| List Screen  | Profile Screen |
| ------------- | ------------- |
| ![list](https://github.com/zeropointo/LilRapApp/blob/main/images/list.png?raw=true)  | ![profile](https://github.com/zeropointo/LilRapApp/blob/main/images/profile.png?raw=true)  |

## Directory structure

    /lib                         Flutter source code
    +---core                     
    |   +---error                Exception and Failure objects
    |   +---network              Interface for network connection checker
    |   +---usecases             Interfaces for data repository api calls
    +---features                 
        +---artist_list           
            +---data             
            |   +---models       Representations of raw data objects
            |   +---repositories Data repository implementations
            |   +---sources      Remote and local datastore implimentations
            +---domain           
            |   +---entities     Representations of processed data objects
            |   +---repositories Interface for data repository
            |   +---usecases     Interfaces for repository api calls
            +---presentation     
                +---bloc         Definition of streams providing data to the UI
                +---pages        Definition of user interface

    /test                        Unit tests for Flutter source code in /lib
    +---core                     
    |   +---network              
    +---features                 
    |   +---artist_list          
    |       +---data             
    |       |   +---models       
    |       |   +---repositories 
    |       |   +---sources      
    |       +---domain           
    |       |   +---usecases     
    |       +---presentation     
    |           +---bloc         
    +---fixtures                 Fake data generation


## Architecture
![image](https://github.com/zeropointo/LilRapApp/blob/main/images/arch_diagram.png?raw=true)
