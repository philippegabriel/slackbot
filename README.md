# slackbot
####Query jira using the jira SQL interface
- see: [`Makefile`](Makefile), target %.csv; SQL queries: [`changeditemHistory.sql`](changeditemHistory.sql) and [`commentsHistory.sql`](commentsHistory.sql)  
- ref: [JIRA SQL interface](https://developer.atlassian.com/display/JIRADEV/Database+Schema) 

####Post the result on a Slack Channel
- see: [`Makefile`](Makefile), target %.sent and [`postSlack.sh`](postSlack.sh)
- ref: [Slack incoming-webhook](https://slack.com/services/new/incoming-webhook)

####Customisation
Edit and customise [`template.config.sh`](template.config.sh), to specify:
- Jira url, database, credentials
- Slack endpoint, channel, bot name, bot emoji
- SQL query, specific parameters, i.e. query interval, names, statuses

####Invocation:
```
make config=<config file> clean all
```
