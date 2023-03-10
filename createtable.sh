#!/bin/bash
report="##### Scenarios:\n"
for file in $(ls reports/*.json); do 
    name=$(jq -r '.[] | .name' $file)
    total_steps=$(jq '.[] | .elements[].steps[].result.status' $file | wc -l)
    failed_steps=$(jq -r '.[] | .elements[].steps[].result.status' $file | grep "failed" | wc -l)
    passed_steps=$(jq '.[] | .elements[].steps[].result.status' $file | grep "passed" | wc -l)
    steps_length=$(jq -r '.[] | .elements[].steps[].name' $file | wc -l)    
    iconStatus=$(if [ $failed_steps -gt 0 ]; then echo ":negative_squared_cross_mark:"; else echo ":heavy_check_mark:"; fi)
    header="| step | keyword | status | location |\n| ------ | ------ | ------ | ------ |\n";
    scenario="<details> <summary>$iconStatus $name | Total: $total_steps | Passed: $passed_steps | Failed: $failed_steps | </summary> \n\n"
    steps=""
        for i in $(seq 0 $(($steps_length-1))); do
            stepName=$(jq -r ".[] | .elements[].steps[$i].name" $file)
            keyword=$(jq -r ".[] | .elements[].steps[$i].keyword" $file)
            status=$(jq -r ".[] | .elements[].steps[$i].result.status" $file)            
            iconStepStatus=$(if [ "$status" = "failed" ]; then echo ":negative_squared_cross_mark:"; else echo ":heavy_check_mark:"; fi)            
            location=$(jq -r ".[] | .elements[].steps[$i].match.location" $file)                        
            header="${header}| $stepName | $keyword | $iconStepStatus $status | $location |\n";
        done
    report="${report}${scenario}${header} </details>\n"
done
SUMMARY=$report
echo "$SUMMARY" >> $GITHUB_STEP_SUMMARY
#echo $report
