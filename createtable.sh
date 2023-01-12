#!/bin/bash


report=""
for file in $(ls reports/*.json); do 
    name=$(jq -r '.[] | .name' $file)
    total_steps=$(jq '.[] | .elements[].steps[].result.status' $file | wc -l)
    failed_steps=$(jq '.[] | .elements[].steps[].result.status' $file | grep "failed" | wc -l)
    passed_steps=$(jq '.[] | .elements[].steps[].result.status' $file | grep "passed" | wc -l)
    steps_length=$(jq -r '.[] | .elements[].steps[].name' $file | wc -l)
    
    header="| step | keyword | status | location |\n| ------ | ------ | ------ | ------ |\n";
    scenario="##### **Scenario** $name \n total: $total_steps | \n"
    steps=""
        for i in $(seq 0 $(($steps_length-1)))
        do   
        stepName=$(jq -r ".[] | .elements[].steps[$i].name" $file)
        keyword=$(jq -r ".[] | .elements[].steps[$i].keyword" $file)
        status=$(jq -r ".[] | .elements[].steps[$i].result.status" $file)
        iconStatus=":heavy_check_mark:"
        if [ "$status" = "failed" ]; then
            iconStatus=":negative_squared_cross_mark:"
        fi
        location=$(jq -r ".[] | .elements[].steps[$i].match.location" $file)                        
        header="${header}| $stepName | $keyword | $iconStatus $status | $location |\n";
        done
    
    #jq -r '.[] | .elements[].steps[].name' report.json
    #header="${header} |$name|$total_steps|$passed_steps|$failed_steps|$steps|\n";
    #echo "name: $name";
    #echo "total_steps: $total_steps";
    #echo "failed_steps: $failed_steps";
    #echo "passed_steps: $passed_steps";
    report="${report}${scenario}${header}"
done

SUMMARY=$report
echo "$SUMMARY" >> $GITHUB_STEP_SUMMARY
#echo $report
