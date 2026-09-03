
# Thesis Project: Social Media Envy, Escapism, and Mental Health

## Highlights
![Image Description](path/to/image1.png)
*Short descriptive caption for image 1.*

![Image Description](path/to/image2.png)
*Short descriptive caption for image 2.*

## General Information
These R scripts comprise the data pipeline and statistical analysis for a thesis project submitted on **June 5th, 2026**. 

### Data Privacy & Replication
* **GDPR Compliance:** For data privacy reasons, the original dataset remains hidden and is not included in this repository. 
* **Structure Visualization:** A provided dummy/replacement dataset is available in the repository to demonstrate how the data was structured and cleaned.
* **Full Replication:** If you wish to replicate the project as a whole, or if you have any questions, please reach out via email at **philip@ruehling.world**.

---

## Disclaimer & Shortcomings
While this investigation yielded significant findings, please note the following limitations:
1. **Cross-Sectional Design:** This study is cross-sectional due to feasibility constraints; no causal directions can be definitively proven over time.
2. **Self-Report Data:** The survey relies on self-reported responses, which are subject to participant bias.
3. **Heteroskedasticity:** The linear model shows moderate heteroskedasticity, likely due to the specific scoring logic of the depression items used in the questionnaire.

---

## Research Motivation
This research is motivated by ongoing global efforts to protect children's and teenagers' mental health, including recent policy initiatives in Australia, Europe, and the US Congress. However, this study argues that the mental health outcomes of internet technologies are far-reaching and extend well beyond younger demographics. 

Furthermore, within the field of **Urban Studies**, there is currently a low engagement with the psychological implications of these daily technologies, as smart cities are primarily evaluated at the macro level.

This study investigates three interconnected claims:
* **Claim 1:** Depression is increasing at an unprecedented rate globally, including in the Netherlands.
* **Claim 2:** Daily life is increasingly spent on internet technologies (e.g., social media), impacting both younger and older populations.
* **Claim 3:** Individuals from lower socioeconomic backgrounds tend to be more vulnerable to the effects of addictive internet technologies due to various factors (e.g., lower access to cultural capital, unfavorable living conditions, and systemic stressors).

---

## Research Aims & Hypotheses
The research was conducted in three distinct phases: two hypothesis-driven stages and one exploratory stage.

### Stage 1: Main Effects (Hypothesis-Driven)
* **H1a:** Individuals experience higher levels of depression when they engage in self-suppressive escapist behavior while using social media.
* **H1b:** Objectively measured socioeconomic status (SES) at the neighborhood level predicts depression via increased suppressive escapist behavior, above and beyond an individual's subjective self-reported SES.

### Stage 2: Mediation & Envy (Hypothesis-Driven)
* **H2a:** Self-suppressive escapist behavior increases depression when a person exhibits *malicious envy* (hostile thoughts/behaviors toward perceived superiors).
* **H2b:** Expansive escapist behavior alleviates depressive symptoms when a person experiences *benign envy* (non-hostile, motivating thoughts toward perceived superiors).

### Stage 3: Baseline & Controls (Exploratory)
* **Assumption Checks:** This stage evaluated contested literature baselines, specifically testing whether a direct relationship between screen time and depression exists when strictly controlling for age and gender.

---

## Repository & File Structure

### 📁 `/Analysis`
Contains three separate analytical R scripts:
* `Cronbach's Alpha`: Evaluates scale reliability following slight adjustments to survey items.
* `Data Descriptives`: Generates primary data visualizations and summary statistics.
* `Regression Analysis`: Executes Stage 1 and Stage 3 models. 
  * `base_mod` and `base_mod_r65_full` address **H1a** and **H1b**.
  * `reverse_mod_r65_full` covers exploratory findings, indicating that existing depressive symptoms also significantly drive suppressive escapist behavior—specifically among younger women living in urbanized areas.

### 📁 `/Data/raw`
* Contains **dummy data** only. 
* The values are non-sensical and serve exclusively to demonstrate the cleaning pipeline and structural formatting.
* **External Data Subfolders:** Includes structural formats for external datasets from the *Centraal Bureau voor de Statistiek* (CBS):
  * `/SES_WOA_CBS`: Objective socioeconomic scoring at the 4-digit postcode level.
  * `/Urbanicity_CBS`: Urban-to-rural scoring index scaled from 1 (highly urban) to 5 (highly rural).

### 📁 `/Mediation Analysis`
Contains two R scripts utilizing Hayes' PROCESS Macro:
* `Macro_Mediation_Analysis_script.R`: Uses **Model 4** to conduct simple mediation analyses for **H2a** and **H2b**.
* **Robustness:** Due to the heteroskedasticity noted in the regression models, bootstrapping was implemented and set to **n = 5000**.

### 📄 `Cleaning script` (Root or Main Script)
* Orchestrates the complete pipeline transforming raw survey inputs into a unified dataset.
* Processes **257 survey responses** from Prolific (comprising roughly 40 Likert-scale items, 1 text input question, and 1 open-ended question per participant).
* Executes the data-join bringing in the external CBS neighborhood-level SES data and urbanicity scores based on participant postcodes.
