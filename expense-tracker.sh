#!/bin/bash

# set perms chmod u+x ./expense-tracker.sh
# end immediately on non-zero exit codes
set -e

# setup local development
if [[ $1 = 'up' ]]; then
    sfdx force:org:create -a ScratchOrg -f config/project-scratch-def.json -s -d 28
    sfdx force:source:push -f
    sfdx force:user:create -f config/consultant-user-def.json
    sfdx force:user:create -f config/finance-user-def.json
    sfdx force:data:tree:import --targetusername ScratchOrg --plan sfdx-out/export-demo-Expense_Category__c-plan.json
    sfdx force:org:open -u ScratchOrg

elif [[ $1 = 'test' ]]; then
    sfdx force:org:create -a TestOrg -f config/project-scratch-def.json
    sfdx force:source:push -u TestOrg -f
    sfdx force:user:create -f config/consultant-user-def.json
    sfdx force:user:create -f config/finance-user-def.json
    sfdx force:org:open -u TestOrg
fi
