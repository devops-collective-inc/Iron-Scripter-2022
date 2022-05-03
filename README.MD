# Iron Scripter 2022

![iron scripter](ironscripterlogo.png)

The Iron Scripter event returned to the PowerShell + DevOps Global Summit. Even though conference attendance was down from previous events, which wasn't unexpected, enthusiasm was high. The three scripting factions battled it out to see whose code would reign supreme. Their efforts were judged by [Anthony Nocentino](https://twitter.com/nocentino), [Sean Wheeler](https://twitter.com/swsamwa), and [Jason Helmick.](https://twitter.com/theJasonHelmick)

The factions were given 60 minutes to develop a PowerShell solution to meet this challenge.

## Background

Your organization’s IT support team would like to use PowerShell more for daily tasks. They would like a module with a set of commands to make their work easier. The module should support PowerShell 7.2. Windows-based servers have ssh installed, and management would like to transition from WSMan to ssh.

The module should have commands that can achieve the following tasks:

+ Manage a local user account. This includes creating the account, setting the password, and local group membership.
+ Get when a server last shut down, booted up, how long it was down, and its uptime. If you can include who last shutdown or rebooted the server, so much the better.
+ A command to show remote connected users using PowerShell remoting. Include both traditional connections and ssh.The output should show the user name, when they connected, how long connected, and if possible their source IP address.
+ A command to show disk usage, especially one that can use ANSI to highlight availability or lack thereof.
+ A unified command to return version information for installed versions of PowerShell, the operating system, and the ssh version.
+ A PowerShell-based version of the Linux *top* command that can be run remotely on a Windows server.

You can assume all Windows servers are running at least Windows Server 2016.

## Requirements

In addition to PowerShell functions that accomplish the given tasks, your finished project should meet the following requirements:

+ Have a module manifest.
+ Run in PowerShell 7.2.
+ Commands with remoting should support alternate credentials.
+ Include help documentation or at least the foundation.
+ A suite of Pester tests for unit testing your solution.

## Grading Criteria

Knowing how to write an effective Pester test is becoming a must-have PowerShell skill. Your submission should have as many Pester tests as possible to validate your code. Depending on your faction, you may want to write your Pester tests first as part of a test-drive development (TDD) effort.

The judges are very interested in how you take advantage of PowerShell 7.2 features.

Commands should write rich objects to the pipeline. Including format and type extension files will give you an edge over the competition.

The remaining grade will be based on how well your overall code structure meets your faction’s philosophy.

## Results

Each faction posted their code to a Github repository. You can find an archive of their work in this repository. The judges reviewed the code, documentation, and Pester tests. Unlike past events, factions were able to submit working code which was executed. The judges were very taken with the submission from Flawless, but it wasn't quite flawless enough. A bug prevented the module from being loaded. In the end, Daybreak prevailed with a combination of working code that met many of the challenge requirements.

You are encouraged to review each faction's work.

## Be Challenged

You can challenge yourself and improve your PowerShell scripting skills by visiting <https://ironscripter.us>. You will find an array of scripting challenges for all skill levels. You are welcome and encouraged to try your hand at as many of them as possible. You should attempt challenges that you feel are above your skill level. The best way to learn PowerShell is by doing.

> All code in this repository is offered as-is and should be considered educational material. Nothing should be considered as production ready.

