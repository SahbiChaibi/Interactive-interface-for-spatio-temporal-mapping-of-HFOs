# Summary
## GUI 
![image](https://github.com/user-attachments/assets/ce08e10d-247f-4274-87f7-2ec097722664)

In our study, six established methods, previously implemented by various research groups, including our own, have been integrated into a comprehensive Graphical User Interface (GUI) [Sahbi Chaibi et al., 2023]. The first method, RMS, is based on the Root Mean Square of the signal. The second, CMOR, utilizes the Complex Morlet Wavelet. The third, named Bump, employs bump modeling for HFO detection and integrates source code from [Vialatte et al., 2009], licensed for research purposes. The fourth method applies iterative Matching Pursuit (MP) [Durka et al., 2001], for which we used the MP4 package under a license restricted to research and educational use. The fifth approach combines Empirical Mode Decomposition (EMD) with the Hilbert-Huang Transform (HHT). Finally, the sixth method uses Decision Tree (D-TREE) analysis, a classical machine learning technique.
Despite these advances, most reported HFO detections in the literature are still associated with high false detection rates, often caused by filtering artifacts, spikes, and sharp waves. As a result, automated HFO detection outputs are typically subject to further rapid inspection by qualified epileptologists or neurologists. This post-processing step is crucial to validate clinically relevant HFOs and eliminate spurious detections.
 * the pargraph

   
