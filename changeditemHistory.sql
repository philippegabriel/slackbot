select cg.author,'changed',ci.field,'of',concat(:jiraUrl,p.pkey,'-',j.issuenum),' ',ci.oldstring,'->',ci.newstring
from changegroup cg
inner join changeitem ci on ci.groupid=cg.id
inner join jiraissue j	on cg.issueid=j.id
inner join project p	on j.project=p.id
where cg.created >= NOW() - :since::INTERVAL
and ci.field in (:ChangedFields)
and cg.author in (:names)
order by cg.created asc;
