# kwanix  
| pure | functional | cache native | silly enabled |  
  
Komac Wrapper As a... nix? :3   
  
yep,,,,,,,,  
  
## Design and General structure:  
The output of kwanix is a single shell script that contains instructions on how to run all predefined updates!  
nix files under `./winget-pkgs` define update rules, and hopes to reduce redundant info for each update task.  
`./lib` stores functions for building each update segment,    
Updates will also get run in paralel for some blazingly fast performance, rocketship emoji.  
## Usage:  
`nix run`   
this will automatically build kwanix, and then run it, performing all defined updates.  
## Binary Cache:
kwanix may use custom patches for komac, and is not based on the latest stable release!    
constructing kwanix shouldn't take long, but compiling komac with all its cargo depencencies might take a minute,,,  
  
So resulting derivations are built automatically inside CI runs here, and then cached on https://kwanix.cachix.org   
  

### !shoutout [komac](https://github.com/russellbanks/Komac) 🔥🚀🚀🚀  

feedback/comments/contributions/whateverelse veryyyyyy welcome :D  
