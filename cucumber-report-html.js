const report = require('multiple-cucumber-html-reporter');

report.generate({
	jsonDir: './reports/',
	reportPath: './reports/html/',
	metadata:{
        browser: {
            name: 'chrome',
            version: '60'
        },
        device: 'Ubuntu latest',
        platform: {
            name: 'ubuntu',
            version: 'latest'
        }
    },
    customData: {
        title: 'Run info',
        data: [
            {label: 'Project', value: 'ArkonNousQA'},            
            {label: 'Cycle', value: 'B11221.34321'},
        ]
    }
});
