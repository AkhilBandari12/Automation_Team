*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    OperatingSystem
Library    String
Library    Process
Library    RPA.Desktop
Library    RPA.Robocorp.WorkItems
Library    RPA.Robocorp.Storage 
Library    RPA.Excel.Files
Library    Telnet
Library    RPA.Word.Application
Library    XML
Library    RPA.Database
Library    RPA.JSON
Library    RPA.FileSystem

#    /home/buzzadmin/Documents/sample_excels/uan_individual.xlsx
*** Variables ***
${username}                   BUZZWORKS2012           
${password}                   Bu$$2024Work$
# ${excel_file_path}            ${EXCEL_FILE_PATH}  
${excel_file_path}             
# ${file_name}                  uan_individual.xlsx
# ${excel_file_path}            ${CURDIR}${/}..${/}sample_excels${/}${file_name}
${DB_TYPE}    psycopg2
${DB_NAME}    uan_individual
${DB_USER}    postgres
${DB_PASS}    flexydial
${DB_HOST}    127.0.0.1
${DB_PORT}    5432

*** Keywords ***
Click Element When Visible
    [Arguments]    ${PreLocator}    ${Elementtype}    ${PostLocator}
    Wait Until Element Is Visible     ${PreLocator}   timeout=120s    error=${Elementtype} not visible within 2m
    Click Element     ${PreLocator}
    Wait Until Element Is Visible    ${PostLocator}    timeout=30s    error= unable to navigate to next page
    Log    Successfully Clicked on ${Elementtype}
Open EPF India Website
    Open Browser    https://www.epfindia.gov.in/site_en/index.php#    chrome    options=add_experimental_option("detach", True)    
    Wait Until Element Is Visible    xpath://*[@id="ecr_panel_1"]    timeout=30s     error=Unbale to launch EPF website..    
Click ECR/Returns/Payment Button
    Click Element     xpath://*[@id="ecr_panel_1"]
    Switch Window        EPFO: Home     timeout=30s
    Maximize Browser Window
    Wait Until Element Is Visible    xpath://*[@id="btnCloseModal"]    timeout=30s     error= Unable to find Alert Popup..
Accept Popup
    Click Button    xpath://*[@id="btnCloseModal"]  
    Log    Opened EPFO login page   
Enter Username and Password
    Wait Until Element Is Visible   xpath://*[@id="username"]    timeout=30s     error=Unable to find username input
    Input Text    xpath://*[@id="username"]     ${username}       
    Input Text    xpath://*[@id="password"]     ${password}                
    Log    Entered username and password   
Click Signin Button
    Wait Until Element Is Visible     //button[@value="Submit"]  timeout=30s
    Click Button        //button[@value="Submit"]
    Sleep    2s
click register individual
    Wait Until Element Is Visible     //*[contains(@class, 'dropdown-toggle') and contains(text(), 'Member')]     timeout=30s
    Click Element   //*[contains(@class, 'dropdown-toggle') and contains(text(), 'Member')]   
    Wait Until Element Is Visible    //ul[@class='dropdown-menu m1']//a[text()='REGISTER-INDIVIDUAL']    timeout=30s  
    Click Element   //ul[@class='dropdown-menu m1']//a[text()='REGISTER-INDIVIDUAL']         


fill and submit form for every no_uan 
    [Arguments]  ${uan}
    ${initial}=    Set Variable    ${uan}[Mr/Mrs]                                        #initial
    Wait Until Element Is Visible    //select[@id="salutation"]/option[text()="${initial}"]    timeout=30s
    Click Element    //select[@id="salutation"]/option[text()="${initial}"]

    Wait Until Element Is Visible    //input[@id='memberName']   timeout=30s                #name
    Input Text    //input[@id='memberName']    ${uan}[Member Name]  
                       
    ${date_without_time}    Set Variable    ${uan}[Date of Birth]                           #dob
    Log    ${date_without_time} 
    ${date_without_time}    Evaluate    datetime.datetime.strptime('${date_without_time}', '%Y-%m-%d %H:%M:%S').strftime('%d/%m/%Y')
    Log    ${date_without_time} 
    Wait Until Element Is Visible    //input[@id='dob']        timeout=30s
    Input Text        //input[@id='dob']     ${date_without_time}

    ${date}    Set Variable    ${uan}[Date of Joining]                                          #doj
    ${date}    Evaluate    datetime.datetime.strptime('${date}', '%Y-%m-%d %H:%M:%S').strftime('%d/%m/%Y')
    Wait Until Element Is Visible   //input[@id="doj"]                 timeout=30s
    Input Text    //input[@id="doj"]    ${date}
    Sleep    1s

    Wait Until Element Is Visible    //input[@id="wages"]             timeout=30s                #Monthly EPF Wages as on Joining
    Input Text    //input[@id="wages"]     ${uan}[Wages as on Joining]

    ${Father's/Husband's Name}=    Set Variable    ${uan}[Father/Husband Name]                   #husband/father
    Wait Until Element Is Visible     //input[@id="fatherHusbandName"]         timeout=30s
    Input Text   //input[@id="fatherHusbandName"]     ${Father's/Husband's Name}

    ${marital_status}=    Set Variable     ${uan}[Marital Status]                                #martial status
    ${first_letter}=    Get Substring    ${marital_status}    0    1
    ${uppercase_first_letter}=    Convert To Upper Case    ${first_letter}
    Wait Until Element Is Visible     //select[@id="maritalStatus"]/option[@value='${uppercase_first_letter}']     timeout=30s
    Click Element    //select[@id="maritalStatus"]/option[@value='${uppercase_first_letter}']
    Log     ${uppercase_first_letter}

    ${Relationship}=    Set Variable    ${uan}[Relationship with the Member]                          #relation
    ${first}=    Get Substring    ${Relationship}    0    1
    ${uppercase_first}=    Convert To Upper Case    ${first}
    Wait Until Element Is Visible    //select[@id="relation"]/option[@value='${uppercase_first}']        timeout=30s
    Click Element    //select[@id="relation"]/option[@value='${uppercase_first}']

    ${Gender}=    Set Variable    ${uan}[Gender]                                                         #gender
    ${uppercase}=    Convert To Upper Case    ${Gender}
    Wait Until Element Is Visible    //input[@name="currentDetails.genderCode" and @value="${uppercase}"]        timeout=30s
    Click Element    //input[@name="currentDetails.genderCode" and @value="${uppercase}"]

    #KYC  DETAILS
    Wait Until Element Is Visible   //*[@id="chkDocTypeId_1"]       timeout=30s
    Unselect Checkbox  //*[@id="chkDocTypeId_1"]
    Click Element    //*[@id="chkDocTypeId_1"]                                  #checkbox
    Sleep    2s
    ${Document_number}=    Set Variable    ${uan}[AADHAAR Number] 
    Wait Until Element Is Visible     //*[@id="docNo1"]         timeout=30s                        #aadhaar number
    Input Text     //*[@id="docNo1"]       ${Document_number}
    ${Document_name}=  Set Variable    ${uan}[Name as on AADHAAR]            #aadhaar name
    Wait Until Element Is Visible    //*[@id="nameOnDoc1"]     timeout=30s  
    Input Text    //*[@id="nameOnDoc1"]     ${Document_name}
    Sleep   1s

    #TICKBUTTON
    Wait Until Element Is Visible      //*[@id="aadhaarConsentChkBox"]     timeout=30s       #tickbutton
    Click Element     //*[@id="aadhaarConsentChkBox"]
    Sleep     1s

    Wait Until Element Is Visible   //*[@id="memreg2"]/input     timeout=30s                    #save button    
    Click Element     //*[@id="memreg2"]/input
    Handle Alert
        # Exit if element is not visible
            ${element_exists}    Run Keyword And Return Status    Element Should Be Visible     xpath=//div[@class='error']
            ${error_text}=     Run Keyword If    ${element_exists}     Get Text    xpath=//div[@class='error']
            Log    ${error_text}
            ${aadhaar} =     Set Variable    ${uan}[AADHAAR Number] 
            ${contains_colon}=    Run Keyword And Return Status    Should Contain   ${error_text}    :
             IF    '${contains_colon}' == 'True' 
                    ${uan_num}=  Split String  ${error_text}  separator=:
                    ${uan} =  Set Variable    ${uan_num}[1] 
                    ${uan_clean}=    Replace String    ${uan}    .    ${EMPTY}
                    ${text}=    Set Variable      ${uan_num}[0]   
                    ${aadhaar_number}=  Set Variable    ${aadhaar} 
                    ${uan_status}=  Set Variable   Newly Added
                    ${uan_num}=    Set Variable     ${uan_clean}
                    ${remarks}=    Set Variable   ${text}
            ELSE  
                    ${aadhaar_number}=  Set Variable  ${aadhaar}   
                    ${uan_status}=  Set Variable   Newly Added
                    ${uan_num}=    Set Variable    None 
                    ${remarks}=    Set Variable     ${error_text}
            END
            Run Keyword    Insert Data Into Database    ${aadhaar_number}    ${uan_status}    ${uan_num}    ${remarks}
            Sleep     3s
           

Handle Alert And Click Radio Button
    [Arguments]  ${locator}                        #radian button purpose
    Run Keyword And Ignore Error    Handle Alert
    Wait Until Element Is Visible    ${locator}    timeout=30s
    Click Element    ${locator}

 fill and submit form for every uan is_present
    [Arguments]  ${uan}
    ${locator}=    Set Variable    //input[@type='radio'][@name='isPreviousEmployee'][@value='Y']
    Wait Until Element Is Visible    ${locator}        timeout= 120s
    # Call the keyword to handle alert and click radio button
    # Handle Alert And Click Radio Button    ${locator}
    Execute JavaScript    document.getElementById('previousEmployementYes').click();
    ${uan_number}=       Set Variable    ${uan}[Universal Account]                              
    Wait Until Element Is Visible    //input[@id="uan"]    timeout=80s
    Input Text    //input[@id="uan"]    ${uan_number}

    ${date_without_time}    Set Variable    ${uan}[Date of Birth]                          #dob
    Log    ${date_without_time} 
    ${date_without_time}    Evaluate    datetime.datetime.strptime('${date_without_time}', '%Y-%m-%d %H:%M:%S').strftime('%d/%m/%Y')
    Log    ${date_without_time} 
    Wait Until Element Is Visible   //input[@id="dobVerify"]               timeout=30s        
    Input Text         //input[@id="dobVerify"]     ${date_without_time}

    ${Name}=      Set Variable    ${uan}[Name as on AADHAAR]                           #name as aadhar            
    Wait Until Element Is Visible     //input[@id="nameVerify"]       timeout=30s                  
    Input Text    //input[@id="nameVerify"]    ${Name}
    
    ${AADHAAR}=   Set Variable    ${uan}[AADHAAR Number]                                #aadhar number
    Wait Until Element Is Visible  //input[@id="aadharVerify"]
    Input Text    //input[@id="aadharVerify"]   ${AADHAAR}
    
    ${date_without_time}    Set Variable    ${uan}[Date of Birth]                           #dob
    Log    ${date_without_time} 
    ${date_without_time}    Evaluate    datetime.datetime.strptime('${date_without_time}', '%Y-%m-%d %H:%M:%S').strftime('%d/%m/%Y')
    Log    ${date_without_time} 
    Wait Until Element Is Visible   //input[@id="dobVerify"]               timeout=30s        
    Input Text         //input[@id="dobVerify"]     ${date_without_time}
    
    #TICK BUTTON
    Wait Until Element Is Visible    //input[@id="aadhaarConsentChkBox"]   timeout=30s            #tickbox
    Click Element   //input[@id="aadhaarConsentChkBox"] 
    
    #verify
    Wait Until Element Is Visible   //input[@value="Verify"]    timeout=30s                      #verify button   
    Click Element     //input[@value="Verify"]

    Wait Until Element Is Visible    //div[@role="alert"]        timeout=200s                   #text extraction 
    ${error_message}=    Get Text    xpath=//div[@role="alert"]
    Log     ${error_message}

    ${close_button_visible}=    Run Keyword And Return Status    Element Should Be Visible    //div[@id="memDetailsModal"]//button[contains(text(),'Close')]   
    ${ok_button_visible}=    Run Keyword And Return Status    Element Should Be Visible   //div[@id="memDetailsModal"]//button[contains(text(),'Ok')] 
    Run Keyword If    ${close_button_visible}    Click Button     //div[@id="memDetailsModal"]//button[contains(text(),'Close')] 
    Run Keyword If    ${ok_button_visible}    Click Button    //div[@id="memDetailsModal"]//button[contains(text(),'Ok')] 
    ${uan_present}=    Set Variable    ${uan}[Universal Account]
    ${aadhaar_number} =     Set Variable    ${uan}[AADHAAR Number] 
    ${uan_status} =  Set Variable     Already Exist  
    ${uan_num} =     Set Variable      ${uan_present}
    ${remarks}=     Set Variable          ${error_message}
    Run Keyword    Insert Data Into Database    ${aadhaar_number}    ${uan_status}    ${uan_num}    ${remarks}
    Sleep    1s
      Wait Until Element Is Visible     ${locator}          timeout=30s
    ${locator}=    Set Variable    //input[@type='radio'][@name='isPreviousEmployee'][@value='N']
    Execute JavaScript    document.getElementById('previousEmployementNo').click();

    # Handle Alert And Click Radio Button    ${locator} 
    Sleep    1s  

Insert Data Into Database
    [Arguments]    ${aadhaar_number}    ${uan_status}    ${uan_num}    ${remarks}
    ${create_table_query}=    Set Variable   CREATE TABLE IF NOT EXISTS UAN_CHECK (ADHAAR VARCHAR(255), "UAN Status" VARCHAR(255), "UAN Number" VARCHAR(255), REMARKS VARCHAR(500))
    Log    ${create_table_query}
    ${check_table_existence}=    Query    SELECT count(*) FROM information_schema.tables WHERE table_name = 'UAN_CHECK'
    Run Keyword Unless    ${check_table_existence}[0][0] > 0    Query    ${create_table_query}
    ${query}=    Catenate    SEPARATOR=    INSERT INTO UAN_CHECK (ADHAAR, "UAN Status", "UAN Number", REMARKS) VALUES ('${aadhaar_number}', '${uan_status}', '${uan_num}', '${remarks}')
    Log    ${query}
    Query  ${query}
    
*** Test Cases ***
Automate EPFO Webpage
    Open EPF India Website
    Click ECR/Returns/Payment Button
    Accept Popup
    Enter Username and Password
    Click Signin Button
    click register individual

   
Check UAN Presence
    [Documentation]    Check if UAN is present or not
    Open Workbook    ${excel_file_path}
        Log    ${excel_file_path}
    ${uan_list}    Read Worksheet As Table    header=True
    FOR    ${uan}    IN    @{uan_list}
        Run Keyword If    '${uan}[Universal Account]' != 'None'    Log    UAN is present: ${uan}    ELSE    Log    UAN is not present for ${uan}
    END

AAdd Data to Database Based on Conditions
    [Documentation]    Add data to the database based on conditions        anty
    Open Workbook    ${excel_file_path}
    Log    ${excel_file_path}
    ${uan_list}    Read Worksheet As Table    header=True
    Connect To Database    ${DB_TYPE}    ${DB_NAME}    ${DB_USER}    ${DB_PASS}    ${DB_HOST}    ${DB_PORT}
    FOR    ${uan}    IN    @{uan_list}
        ${aadhaar_number}=    Set Variable   ${uan}[AADHAAR Number] 
        ${account} =  Set Variable               ${uan}[Universal Account]
        # ${query_result}=    Query   Select Count(adhaar) FROM uan_individual WHERE adhaar = '${aadhaar_number}'    
        # Log    ${query_result}
        # IF    ${query_result}[0][0] == 0
            IF    '${uan}[Universal Account]' != 'None'
                fill and submit form for every uan is_present    ${uan}
            ELSE
                fill and submit form for every no_uan   ${uan}     
            END 
    END

