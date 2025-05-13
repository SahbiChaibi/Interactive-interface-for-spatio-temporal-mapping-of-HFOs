# HFOsMap: An interactive GUI for reliable detection and brain mapping of High-Frequency Oscillations (HFOs) features in epilepsy
Most clinicians are not deeply familiar with computer programming skills. Therefore, simplifying and integrating various standalone diagnostic algorithms into user-friendly graphical interfaces can be highly beneficial for them in this regard. Over the last two decades, HFOs have emerged as potential biomarkers in epilepsy diagnosis and monitoring. The presented software is a plug-and-play interactive Graphical User Interface (GUI) designed for detecting and tracking the underlying mechanisms of HFOs biomarkers. It incorporates six validated HFO detection methods, followed by better reduction of false detection rates. It also tracks changes of HFO characteristics across different brain regions and temporal clinical stages. 
Keywords: Epilepsy, HFOs, detection, verification and checking, features, brain mapping.


# HFOsMap workflow
The process of reliable detection and brain mapping of High-Frequency Oscillation (HFO) features in epilepsy involves four main stages:
Stage 1 – EEG data reading.
Stage 2 – HFO detection method selection.
Stage 3 – Manual verification and validation of relevant detected HFO results.
Stage 4 – Mapping of HFO features.
A simplified flowchart illustrating the processes integrated into our software is shown in the figure below.
![image](https://github.com/user-attachments/assets/a152e8fd-6790-4ee6-8850-05741ab6f6dd)

# Related Article
This project is related to the research article titled:
“Interactive Interface for Spatio-Temporal Mapping of the Epileptic Human Brain Using Characteristics of High-Frequency Oscillations (HFOs)”,
published in the Biomedical Signal Processing and Control journal (2023).
You can access the article via the following DOI link: https://doi.org/10.1016/j.bspc.2023.105041
Authors grant a nonexclusive license to use this software and documentation for education and research. No part of the software or documentation can be included in any commercial product without prior obtaining a written permission of the authors. Please cite the following reference:
Chaibi S, Mahjoub C, Le Bouquin Jeannes R, & Kachouri A. Interactive Interface for Spatio-Temporal Mapping of the Epileptic Human Brain Using Characteristics of High-Frequency Oscillations (HFOs). Biomedical Signal Processing and Control, 2023, 85, 105041. https://doi.org/10.1016/j.bspc.2023.105041.

## Stage 1 – EEG Data reading
Here is a brief summary in bullet points of the first stage:
1. Browse button: Allows the user to upload EEG data files in .mat format.
2. Sampling frequency field: Editable text box to set the sampling frequency for EEG signals.
3. Electrode selector: An editable text box to specify the EEG electrode index for analysis (HFO detection is performed electrode by electrode for detailed verification).
5. Window(s) field: Allows the user to define the length of the EEG signal segment to display.
6. Upper display area: Shows the selected EEG signal channel and highlights detected HFO events in red when detected.
7. Middle graph: Displays the filtered signal, either in the time domain or time-frequency domain, depending on the detection method.
8. Bottom graph: Indicates the start and end times of each detected HFO event.
9. Zoom sliders: Vertical and horizontal sliders enable zooming on amplitude and time during HFO verification.
![image](https://github.com/user-attachments/assets/c3887e05-6a01-4709-9f38-34439a4f73ed)

## Stage 2 – Selection of the HFO detection method & HFOs detection
Here is an snapshotw examples with detection of HFOs with six validates methods
![image](https://github.com/user-attachments/assets/d3c642b9-2fae-44c1-ba4f-8b5b46064070)
![image](https://github.com/user-attachments/assets/c4d5a095-c30c-40e6-9a03-10c7ea7b7653)
![image](https://github.com/user-attachments/assets/44d57d7f-8df5-49a9-825b-2ccdec48c2ff)
![image](https://github.com/user-attachments/assets/f2597ae8-0b0c-481d-b8f7-08926fc45cb5)
![image](https://github.com/user-attachments/assets/7bb235ec-0fa2-4f87-bfc7-193d0d6f4afd)
![image](https://github.com/user-attachments/assets/d910c5d6-6b98-4595-8410-27b0a2f442a9)

## Stage 3 – Verification of detected HFOs
![image](https://github.com/user-attachments/assets/46528472-507f-46b3-84d4-65db2bbe5170)


![image](https://github.com/user-attachments/assets/1bc524f7-dcb1-4b94-bfd4-710e226b6a6b)
![image](https://github.com/user-attachments/assets/dbc5df3e-8e06-4a01-9ea8-fdf96dd30035)
![image](https://github.com/user-attachments/assets/1fee0bd4-50c8-41c7-93e5-e1b1c261afae)

Stage 4 – Mapping of HFO features

![image](https://github.com/user-attachments/assets/13edbedc-15d9-4e9d-8846-630a2a71dc02)

# Launch HFOsMap
You can start the project by running the Main.m file in the root directory. This loads the GUI settings. 
## Data availability
The intracranial EEG dataset used in this study for experiment test is exclusively restricted to the Montreal Neurological Institute and Hospital (Canada) to protect patients’ privacy and confidentiality.
the usped dataset in this projected is reffered to as ppp.mat, includels a variablelike allEEG thant contains all EEG electrodes.



