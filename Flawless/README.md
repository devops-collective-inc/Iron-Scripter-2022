# 2022-Main-Challenge
Repository for IronScripter 2022 Main Challenge.

Request access to this repository from the `#faction-flawless` slack channel. If you do not get access, you cannot open pull requests to merge your changes.

Clone the project:
```powershell
git clone https://github.com/FlawlessFaction/2022-Main-Challenge
```

Configure Git
```
# Setup your usernamd and email
git config user.name "First Last"
git config user.email "first.last@domain.com"

# make VSCode the default editor
git config core.editor "code --wait"
```

# Continuous Integration
We are using pair programming for the competition so we can do full continuous integration. Once you have a local clone, this is the general workflow.


## Make changes
Make your changes and commit them into main. Use VSCode or these git commands.

```powershell
git add -A
git commit -m "description of my changes"
```

Feel free to make multiple commits as needed.

## Fetch and Push Changes

During the competition, it is helpful to frequently fetch updates and push changes. Make sure you have everything committed locally then run these commands.

```powershell
git fetch
git rebase -i origin/main
git push
```

Reach out for help if you are new to rebasing or resolving merge conflicts.


# VSCode
Code format and style settings are enforced by VSCode.


# Tests

Used Pester 5 for tests and place them into the `./tests` folder.

Execute tests by running this command:

```powershell
Invoke-Pester
```
