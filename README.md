# PhDDissertationCode_AVKalia
This repository contains models, parameter data, control algorithms and results data for Doctoral Dissertation titled **"Contributions to Passenger and Commercial Hybrid Electric Vehicle Energy Management Control"** submitted by Aman Ved Kalia in June, 2020 at University of Washington, Seattle.

> The models and functions were made in **MATLAB 2018b** and would run properly in that version of the application software.

The link to the dissertation will be added once published! - **TBA**

***

## 1. Running Passenger Vehicle Model

The passenger vehicle model is based on a Series Hybrid Electric Vehicle/ Extended Range Electric Vehicle architecture. The parameters can be changed to represent a different SHEV/EREV architecture vehicle.

Follow these steps to run the model:
<ol>
  <li> Access the Matlab script file "startPwrLossMdl.m" inside the Passenger_Vehicle_Model directory. </li>
  <li> The selectable parameters in the script can be updated as desired. </li>
  <li> Run the script </li>
  <li> The script should open a model named "SHEV_Camaro_PwrLossMdl.slx" </li>
  <li> There are some masked blocks inside the model that can be updated and manipulated to run as desired. </li>
</ol>

***

## 2. Running Commercial Vehicle Platoon Model

The commercial vehicle platoon model implements three different architectures inside the main environment. These include a conventional, series-parallel hybrid electric and battery electric 6x4 Class 8 long haul semi-truck. The trucks implement forward looking perception system and a framework for vehicle-to-vehicle (V2V) communication.

Follow these steps to run the model:
<ol>
  <li> Access the Matlab script file "startHetPlatoonModel.m" inside the Commercial_Vehicle_Platooning_Model > Models directory. </li>
  <li> The selectable parameters in the script can be updated as desired. </li>
  <li> Run the script </li>
  <li> The script should open a model named "het_platoon_model.slx" </li>
  <li> There are some masked blocks inside the model that can be updated and manipulated to run as desired. </li>
</ol>

***

## 3. Running Energy Consumption Planner

The energy consumption planner is an application built to integrated Google API tools to generate an estimated power and energy profile for the SHEV/EREV. The planner can be changed to estimate the same for commercial vehicles by updating the road load coefficients used.

Follow these steps to run the application:
<ol>
  <li> Setup your personal Google API Key online. </li>
  <li> Save the personal key using "saveGoogleAPIKey.m" function in GoogleAPI_Functions directory for future use.</li>
  <li> Run the script "runEnergyConsPlanner.m" in Energy_Consumption_Planner to initiate the application. </li>
  <li> Enter required Origin and Destination information. </li>
  <li> The data obtained can be saved by uncommenting the save section in the script and changing the directory as desired. </li>
</ol>

***

> **P.S.**: The plot_google_map directory inside GoogleAPI_Functions was not authored by the owner of this repository. All the contents of that directory belong to *Zohar Bar-Yehuda* and the license present in that directory superscedes the LICENSE for this repository. The owner of this repository acknowledges the plot_google_map tool developed by *Zohar Bar-Yehuda* in generating google map plots for visualization.

***

For any questions regarding the model or contents of this repository send an email to amanved[dot]kalia[at]gmail[dot]com with the subject line starting with [PhDRepo]:
