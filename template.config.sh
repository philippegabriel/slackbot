#Custom config file for slackbot
#
#
############################Jira config####################################################
#psql environment variable, see: http://www.postgresql.org/docs/9.4/static/libpq-envars.html
export PGHOST=
export PGDATABASE=
export PGUSER=
export PGPASSWORD=
#config for the sql queries
#psql expects variable to be exactly in this format: i.e. 'item1','item2',...
#query interval - needs to be in sync with cron period
export since="'5 mins'"
#Set of people for report
export names="'user1','user2'"
#Changed fields
export ChangedFields="'status'"
##############################Slack config############################################
#see: https://slack.com/services/new/incoming-webhook
export endpoint=
export channel=
export botname=
