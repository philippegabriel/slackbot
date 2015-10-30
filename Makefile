#!/usr/bin/make -f
# philippeg feb2014
# Generate csv files
# with persons who were assigned or commented on jira tickets, between a set of dates
# using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema 
#
.PHONY: login clean reallyclean deploy test post
############################config file#######################################################
SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
configFile:=$(SELF_DIR)/.config
###########################jira params########################################################
#jira server params, read from .config file
config=$(lastword $(shell grep $(1) $(configFile)))
host:=$(call config,'host')
dbname:=$(call config,'dbname')
username:=$(call config,'username')
password:=$(call config,'password')
#psql generic methods
setJiraPass=export PGPASSWORD=$(password)
ConnectToJira=psql --host=$(host) --dbname=$(dbname) --username=$(username)
#Define function to set multiple argument list in a compatible psql format, i.e. 'item1','item2',...
qw=$(shell echo $(1) | sed "s/\([^,]*\)/'\1'/g")
##########################customise this section###############################################
#query interval - needs to be in sync with cron period
since:=5 mins
#jira projects, e.g. CA, CP, SCTX... 
projects:=CA,CP,SCTX,XOP
#Set of people for report
names=svcacct_xs_xenrt,philippeg
ChangedFields=status
########################end of custom section##################################################
########################autogen vars###########################################################
targets=$(subst .sql,.csv,$(shell ls *.sql))
namesPsqlFormat=$(call qw,$(names))
projectsPsqlFormat=$(call qw,$(projects))
sincePsqlFormat=$(call qw,$(since))
ChangedFieldsPsqlFormat=$(call qw,$(ChangedFields))
###############################################################################################
all: clean $(report) 
%.csv: %.sql
	$(setJiraPass) ; $(ConnectToJira) \
	--field-separator=" " --no-align --tuples-only 	\
	--variable=since="$(sincePsqlFormat)" \
	--variable=names="$(namesPsqlFormat)" \
	--variable=ChangedFields="$(ChangedFieldsPsqlFormat)" \
	-f $< > $@
post:
	./postSlack.sh channel '#devtest' botname 'Hello' msg 'Hello from script' emoji ':package:'
login:
	$(setJiraPass) ; $(ConnectToJira)
clean: 
	rm -f $(targets) $(report) $(ticketlist)
reallyclean:
	rm -f *.csv
deploy:
	cp -f * $(deployTarget)
	cp -f $(inclpath)$(inclfile) $(deployTarget)
test: reallyclean $(targets) 
	cat $(targets)
	
