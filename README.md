# kwanix  
  
Komac Wrapper As a nix :3  
  
yep,,,,,,,,  
  
dis wat me gonna use for https://github.com/microsoft/winget-pkgs :3  
my previous automation setup was just a bunch of loose scripts and shell aliases,,,  
  
## Design and General structure:  
nix files under `./winget-pkgs` define update rules, reducing redundant info for each update task.  
`./lib` stores functions for building the main updater script that runs all the updates in parralel.  
Flake itself will build kwanix  
## Usage:  
Just `nix run`   
this will automatically run all updates.  
  
feedback/comments/contributions/whateverelse veryyyyyy welcome :D  
