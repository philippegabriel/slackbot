#!/usr/bin/make -f
# philippeg oct2015
# query jira using the jira SQL interface
#see: https://developer.atlassian.com/display/JIRADEV/Database+Schema 
#Post the result on a Slack Channel
#see: https://slack.com/services/new/incoming-webhook
#
.PHONY: login clean env csv test
config:=.config.sh 
csv:=$(subst .sql,.csv,$(shell ls *.sql))
targets:=$(subst .csv,.sent,$(csv))
###############################################################################################
all: $(targets)
%.csv: %.sql
	. ./.config.sh ; psql \
	--field-separator=" " --no-align --tuples-only 	\
	--variable=since="$$since" \
	--variable=names="$$names" \
	--variable=ChangedFields="$$ChangedFields" \
	-f $< > $@
%.sent: %.csv 
	. ./.config.sh ; ./postSlack.sh < $<
	echo "sent $< at `date`" > $@
login:
	. ./.config.sh ; psql
clean: 
	rm -f $(csv) $(targets)
env:
	. ./.config.sh ; env | sort	
csv: $(csv)
	cat $(csv)	
test:
	@echo $(csv) $(targets)		
