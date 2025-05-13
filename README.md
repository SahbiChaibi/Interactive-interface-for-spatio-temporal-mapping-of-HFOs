# HFOsMap: An interactive GUI for reliable detection and brain mapping of High-Frequency Oscillations (HFOs) features in epilepsy
Most clinicians are not deeply familiar with computer programming skills. Therefore, simplifying and integrating various standalone diagnostic algorithms into user-friendly graphical interfaces can be highly beneficial for them in this regard. Over the last two decades, HFOs have emerged as potential biomarkers in epilepsy diagnosis and monitoring. The presented software is a plug-and-play interactive Graphical User Interface (GUI) designed for detecting and tracking the underlying mechanisms of HFOs biomarkers. It incorporates six validated HFO detection methods, followed by better reduction of false detection rates. It also tracks changes of HFO characteristics across different brain regions and temporal clinical stages. 

Keywords: Epilepsy, HFOs, detection, verification and checking, features, brain mapping.

# HFOsMap workflow
The process of reliable detection and brain mapping of High-Frequency Oscillation (HFO) features in epilepsy involves four main stages:
Stage 1 – EEG data reading.
Stage 2 – HFO detection method selection.
Stage 3 – Rapid manual verification and validation of relevant detected HFO results.
Stage 4 – Mapping of HFO features.
A simplified flowchart illustrating the processes integrated into our software is shown in the figure below.
![image](https://github.com/user-attachments/assets/a152e8fd-6790-4ee6-8850-05741ab6f6dd)

# Related Article
This project is related to the research article titled:
“Interactive Interface for Spatio-Temporal Mapping of the Epileptic Human Brain Using Characteristics of High-Frequency Oscillations (HFOs)”,
published in the Biomedical Signal Processing and Control journal (2023).
You can access the article via the following DOI link: https://doi.org/10.1016/j.bspc.2023.105041.
Anyone can use this software for academic applications providing they properly reference our work as follows: Chaibi S, Mahjoub C, Le Bouquin Jeannes R, & Kachouri A. Interactive Interface for Spatio-Temporal Mapping of the Epileptic Human Brain Using Characteristics of High-Frequency Oscillations (HFOs). Biomedical Signal Processing and Control, 2023, 85, 105041. https://doi.org/10.1016/j.bspc.2023.105041.

Authors grant a nonexclusive license to use this software and documentation for education and research. No part of the software or documentation can be included in any commercial product without prior obtaining a written permission of the authors. 

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

## Stage 2 – Selection of the HFOs detection method and adjustment of its internal hyperparameters
1. The six radio buttons shown in the GUI are used to select one method from the following six proposed methods: RMS, CMOR, BUMP, MP, HHT and D-TREE.
2. Before running the chosen method, the user can adjust the appropriate hyperparameters associated with the selected method.
3. Pressing the "Run" button executes the internal functionalities of the chosen method.

Some snapshot examples of HFO detection using the six proposed methods are shown in the figures below:

![image](https://github.com/user-attachments/assets/d3c642b9-2fae-44c1-ba4f-8b5b46064070)
![image](https://github.com/user-attachments/assets/c4d5a095-c30c-40e6-9a03-10c7ea7b7653)
![image](https://github.com/user-attachments/assets/44d57d7f-8df5-49a9-825b-2ccdec48c2ff)
![image](https://github.com/user-attachments/assets/f2597ae8-0b0c-481d-b8f7-08926fc45cb5)
![image](https://github.com/user-attachments/assets/7bb235ec-0fa2-4f87-bfc7-193d0d6f4afd)
![image](https://github.com/user-attachments/assets/d910c5d6-6b98-4595-8410-27b0a2f442a9)

   4.The detected HFO events are shown graphically in the upper area, highlighted in red within the unfiltered signals, and in the bottom graph, indicated by their start and end times. Additionally, detection results (HFOs and their features) can be displayed numerically by clicking on the 'Detection Results' button, as shown in this figure:
   
 ![image](https://github.com/user-attachments/assets/46528472-507f-46b3-84d4-65db2bbe5170)
   
## Stage 3 – Rapid checking of detected HFOs 

There is an inherent tradeoff between the correct detection rate and the false detection rate in HFO detection approaches, often resulting in high false detection rates (up to 80%). Thus, automatic HFO detection results require review by trained experts to avoid inaccuracies, which is particularly important when studying epileptic connectivity networks. A rapid examination of detected results, including candidate HFOs, is facilitated through the 'Detection Results' button, which moves the user to an interactive window (as shown in the last figure above) containing detailed analytical information related to the characteristics of candidate HFO patterns.

1. Show buttons  [1,2,.., N] allow the user to plot the start and end time positions of different candidate HFO bursts by marking the start-end times with two vertical lines for 1D methods (RMS and D-TREE methods), or in the time-frequency domain for the remaining approaches.
![image](https://github.com/user-attachments/assets/49f5a295-a1c1-472d-9747-296fc14f66f2)
![image](https://github.com/user-attachments/assets/c75bc97a-5241-4d16-a8b1-8874c8918460)

2. The expert reviewer can track each HFO pattern individually in both time and time-frequency domains (80-500 Hz) to determine its validity and decide whether to retain or discard it.
   
3. The main plotted characteristics are: the duration, the inter-duration, the occurrence rate, the power, and the average frequency of condidate HFOs.
   ![image](https://github.com/user-attachments/assets/95c52f5e-1c8a-4298-ab77-93518a889e4d)
   
4. In the case of spurious HFOs, they can be discarded using the 'Delete' buttons in the right colum.
![image](https://github.com/user-attachments/assets/2ea711fe-43aa-43c8-be2f-756806399da3)




Stage 4 – Mapping of HFO features

![image](https://github.com/user-attachments/assets/13edbedc-15d9-4e9d-8846-630a2a71dc02)



# Launch HFOsMap
You can start the project by running the Main.m file in the root directory. This loads the GUI settings. 
## Data availability
The intracranial EEG dataset used in this study for experiment test is exclusively restricted to the Montreal Neurological Institute and Hospital (Canada) to protect patients’ privacy and confidentiality.
The dataset used in this project is referred to as ppp.mat, which includes a variable named allEEG that contains data from all EEG electrodes.



