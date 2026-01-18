# kwanix  
  
Komac Wrapper As a... nix? :3   
  
yep,,,,,,,,  
  
## Design and General structure:  
nix files under `./winget-pkgs` define update rules, reducing redundant info for each update task.  
`./lib` stores functions for building each update segment that will eventually be composed togheter,  
so, in essence, the output of kwanix is a single shell script that contains instructions on how to run all predefined updates!  
Updates will also get run in paralel for some blazingly fast performance, rocketship emoji.  
## Usage:  
`nix run`   
this will automatically build kwanix, and then run it, performing all defined updates.  
NB: kwanix is pure!    
meaning you don't need to built it each time, and it's derivation is cached like any other  
  

### !shoutout [komac](https://github.com/russellbanks/Komac) 🔥🚀🚀🚀  

feedback/comments/contributions/whateverelse veryyyyyy welcome :D  
