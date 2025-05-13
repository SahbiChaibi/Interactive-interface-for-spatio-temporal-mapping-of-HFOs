# HFOsTrack: An interactive GUI for reliable detection and brain mapping of High-Frequency Oscillations (HFOs) features in epilepsy
In the neurological field, most clinicians are not deeply familiar with signal and image processing, artificial intelligence, or programming skills. Therefore, simplifying and integrating various existing algorithms into user-friendly graphical interfaces can be highly beneficial for them in this regard. Recently, High-Frequency Oscillations (HFOs) have emerged as key biomarkers in epilepsy research and diagnosis. The presented software is a plug-and-play interactive Graphical User Interface (GUI) designed for detecting and tracking the underlying mechanisms of HFOs biomarkers. It incorporates six validated HFO detection methods followed by reduction of false detection rates. It also offers new brain mapping capabilities to monitor HFO characteristics across different brain regions and clinical stages. This tool helps bridge the gap between research and clinical practice, enhancing the understanding of clinical relevance and applicability of HFOs in epilepsy.

# HFOsTrack workflow
The process of reliable detection and brain mapping of High-Frequency Oscillation (HFO) features in epilepsy involves four main stages:
Stage 1 – Data reading,
Stage 2 – Selection of the HFO detection method,
Stage 3 – Verification of detected HFOs,
Stage 4 – Mapping of HFO features.
A simplified flowchart illustrating the functionalities of our software is shown in the figure below.
![image](https://github.com/user-attachments/assets/a152e8fd-6790-4ee6-8850-05741ab6f6dd)

# Related Article
This project is associated with the research article titled:
“Interactive Interface for Spatio-Temporal Mapping of the Epileptic Human Brain Using Characteristics of High-Frequency Oscillations (HFOs)”,
published in the Biomedical Signal Processing and Control journal (2023).
You can access the article via the following DOI link: https://doi.org/10.1016/j.bspc.2023.105041
Citation:
Chaibi S, Mahjoub C, Le Bouquin Jeannes R & Kachouri A. Interactive Interface for Spatio-Temporal Mapping of the Epileptic Human Brain Using Characteristics of High-Frequency Oscillations (HFOs). Biomedical Signal Processing and Control(2023), 85, 105041. https://doi.org/10.1016/j.bspc.2023.105041.

# Main parts of the proposed GUI
Here is a brief summary in bullet points of the described GUI features:
1. Browse button: Allows the user to upload EEG data files in .mat format.
2. Sampling frequency field: Editable field to set the sampling rate for EEG signal processing.
3. Electrode selector: Editable field to choose the EEG electrode index for analysis (HFO detection is done electrode by electrode for individual review).
4. Window(s) field: Lets the user define the length of the EEG signal segment to display.
5. Upper display area: Shows the selected EEG signal segment and highlights detected HFO events in red.
6. Middle graph: Displays the filtered signal, either in the time domain or time-frequency domain, depending on the detection method.
7. Bottom graph: Indicates the start and end times of each detected HFO event.
8. Zoom sliders: Vertical and horizontal sliders enable zooming on amplitude and time during HFO verification.


