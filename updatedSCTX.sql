-- List updated SCTX tickets since a given interval of time
-- Using the jira SQL interface, see: https://developer.atlassian.com/display/JIRADEV/Database+Schema
select 'Updated: ',concat(:jiraUrl,p.pkey,'-',j.issuenum)
from jiraissue j, project p
where j.created >= NOW() - :since::INTERVAL  
and p.pkey='SCTX'
and j.project=p.id
order by j.created asc;
