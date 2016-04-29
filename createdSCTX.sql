-- List created SCTX jira ticket since a given interval 
-- Using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema
select j.reporter,'created: ',concat(:jiraUrl,p.pkey,'-',j.issuenum)
from jiraissue j, project p
where j.created >= NOW() - :since::INTERVAL  
and p.pkey='SCTX'
and j.project=p.id
order by j.created asc;
