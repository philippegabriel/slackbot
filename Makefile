#!/usr/bin/make -f
# philippeg oct2015
# query jira using the jira SQL interface
#see: https://developer.atlassian.com/display/JIRADEV/Database+Schema 
#Post the result on a Slack Channel
#see: https://slack.com/services/new/incoming-webhook
#
.PHONY: login clean env csv test

config:=config.slackbot/.config.test.sh 
slackbotId:=$(shell . ./$(config) ; echo $$slackbotId)
sql:=$(shell ls *.sql)
csv:=$(subst .sql,.$(slackbotId).csv,$(sql))
targets:=$(subst .$(slackbotId).csv,.$(slackbotId).sent,$(csv))
###############################################################################################
all: $(targets)
%.$(slackbotId).csv: %.sql
	. ./$(config) ; psql \
	--field-separator=" " --no-align --tuples-only 	\
	--variable=since="$$since" \
	--variable=names="$$names" \
	--variable=ChangedFields="$$ChangedFields" \
	-f $< > $@
%.$(slackbotId).sent: %.$(slackbotId).csv 
	. ./$(config) ; ./postSlack.sh < $<
	echo "sent $< at `date`" > $@
login:
	. ./$(config) ; psql
clean: 
	rm -f $(csv) $(targets)
env:
	. ./$(config) ; env | sort	
csv: $(csv)
	cat $(csv)	
test:
	@echo $(slackbotId)
	@echo $(sql) $(csv) $(targets)		
