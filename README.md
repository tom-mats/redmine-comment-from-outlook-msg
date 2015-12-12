# redmine-comment-from-outlook-msg

## Purpose

* Insert mail message from msg(Outlook)/eml file to description/comments

## Procedures

Use the following hook

* :controller_issues_new_before_save
* :controller_issues_edit_before_save

Use attachment file data from AttachmentsHelper

attachment files have been uploaded before user submit the new/change issues

## license

MIT
