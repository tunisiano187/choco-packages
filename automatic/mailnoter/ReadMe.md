[![](https://img.shields.io/chocolatey/v/mailnoter?color=green&label=mailnoter)](https://chocolatey.org/packages/mailnoter) [![](https://img.shields.io/chocolatey/dt/mailnoter)](https://chocolatey.org/packages/mailnoter)

## Mailnoter
MailNoter is a small tool to help gathering notes from various applications, but specifically from browsers.

There are many tools and applications out there which help to keep a repository of personal notes, and even though some of them are very good at what they do, 
they all either use a proprietary format to store the notes (what would happen to my notes if the application isn't supported anymore and stops working on future OS versions?)
only store notes as plain text, require non WYSIWYG input (e.g., Wikis), don't allow attachments, don't work if there's no network access, or are just plain ugly.

So I'm keeping my notes in my email account:

* open storage format
* available from different computers and OS
* works offline
* usable with any email client
* usable through a web browser (no need to install anything if I'm at a place where I can't just install apps)
* easily searchable (either through the web interface (did I mention I'm using Gmail?)), through desktop search engines or the email client itself

And with Gmail, I can add tags to my notes very easily, which makes searching them even easier.

So how does MailNoter help here? (Please don't complain about the name: I had to choose something that isn't used by some other application, and "MailNoter" returned
exactly two hits in Google: both because of a typo).

Without MailNoter, if I want to create a note from a part of a website or code snipped in the IDE, I had to:

1. create a new mail
2. go back to the browser/IDE/whateverApplication
3. select the part I want to keep as a note
4. hit Ctrl-C to copy it to the clipboard
5. go back to the new email I started
6. paste the text in
7. enter a meaningful subject for the email
8. enter the "To:" address
9. hit "Send"

with MailNoter however:

1. select the text in the browser/IDE/whateverApplication
2. hit the hotkey (e.g., Win+PrintScreen)
3. hit "Send"

MailNoter, when the hotkey is pressed, automatically copies the selected text into a new email, fills in the "To:" address and also fills in the email subject automatically. No need to manually copy/paste, create new email, fill in the same stuff over and over again.

Another nice feature of MailNoter: selecting files in Explorer and hitting the hotkey will create a new email, with the selected files already added as an attachment. Image files are not added as an attachment though, they're added inline.

So, as I said: it's a small tool which doesn't do much. But it helps me with gathering my notes.

### Package-specific issue
If this package isn't up-to-date for some days, [Create an issue](https://github.com/tunisiano187/Chocolatey-packages/issues/new/choose)

Support the package maintainer and [![Patreon](https://cdn.jsdelivr.net/gh/tunisiano187/Chocolatey-packages@d15c4e19c709e7148588d4523ffc6dd3cd3c7e5e/icons/patreon.png)](https://www.patreon.com/tunisiano)
