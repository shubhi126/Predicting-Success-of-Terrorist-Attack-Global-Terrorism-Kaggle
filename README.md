# Predicting-if-Terrorist-Attack-will-be-Successful-or-Not---using-Global-Terrorism-Database-GTD
My fictitious firm, GDSMC Global, is a security consultancy focusing on supporting governments around the world in understanding, predicting, and stopping terrorism attacks. Our goal is to allow individual nation states to better deploy security resources to reduce the likelihood of successful terrorism in the future, and to understand what are the likely coming costs of terrorism so that resources can be set aside, in advance, to rebuild after inevitable and unfortunate attack.Although governments can submit their own internal security data to us for study, our models are constructed using the Global Terrorism Database (GTD) maintained by the National Consortium for the Study of Terrorism and Responses to Terrorism at the University of Maryland ( http://start.umd.edu/gtd/ ).

I specifically focused on data collected after 2012, when the GTD automated, standardized, and
expanded their recording methods.

Starting with Business Understanding

Global deaths from terrorism rose to over 29,000 in 2016 from a little more than 11,000 in 2007. The 2016
economic impact of terrorism was estimated to be 130.7 billion dollars. Perhaps surprisingly, the majority
(82.7%) of the terrorism’s cost comes not from the immediate attack, but from indirect costs such as lost
productivity, perceived loss of safety and security in a society, and disruption to tourism or travel.1 With
10,887 successful attacks in 2016, per GTD records, the mean cost per attack comes to $120,000.
By giving insight into the factors that alter the likelihood of a successful terrorist action, we can help
governments identify areas of vulnerability for existing security resources and to value the benefits of new
security resources. By providing insight into predicted efficacy of terrorism over a given period of time,
governments can mitigate the substantial indirect costs of terrorism by reserving financial resources to
compensate for indirect losses following an attack.

In short, we aim to help governments stem the loss of life and property through insight into the factors
that determine terrorism success. And, should terrorism occur, we aim to give governments the tools to
predict the budgets they will need to minimize the impact felt to society.
Data Understanding

We chose the GTD as our data source because it is regarded as authoritative, frequently cited by media
and academic publication. The GTD is extraordinarily comprehensive, including detailed information on
more than 170,000 attempted and actual terrorist attacks dating back to 1970.
The GTD tracks a wide and diverse set of factors in both structured and semi-structured formats. A
sampling of variables included are: dates and times of attack, value of property damage, if hostages were
taken (and how many), if hostages were killed (and how many), if hostages were freed (and how many), weapons used, if the attack was “successful”, if the attack was claimed, the latitude and longitude of the
attack, and proximity to an urban center. There are also free-written text fields that document summaries
of the attacks, details on the weapon(s) used, and the motive of the attackers, among many others. In total,
there are 135 fields.

Accompanying the dataset is a comprehensive Codebook detailing all variables, their method of collection,
and the meaning of their values.2 The codebook details large systemic changes in data collection beginning
in 2012, allowing automation to be used to collect information from openly available media articles,
filtered by keyword, which is then reviewed by a collection team. As a result, there is a significant shift
in the volume of recorded attacks in 2012, and a large positive shift in the consistency of
comprehensiveness of records.

Even after 2012, however, several areas of potential difficulty persist in the data. Many of the fields, even
the dummy fields, include an option for “unknown,” taking the form of “-99” in numerical fields and “-9”
in fields that would otherwise be dummy fields. The prevalence of “unknown” or “NA” entries seems to
correspond with the reliability of the local media, and so the extent of this issue varies a great deal from
country to country. Going back further in time creates even greater issues, as the GTD relies heavily on
open media sources to collect its records. Before the wider prevalence of the internet, the majority of
recorded terrorist attacks in the database occur in the developed world, with a strong bias towards the
United States in particular.


Data Preparation

First, I eliminated most of the free text variables, as they were either uninformative or, more often,
difficult to measure and utilize in empirical models.

Second, during my initial data visualization check, I found that there is a dramatic surge in recorded
attacks starting in 2012, an artefact of changes in data collection methodology. Therefore, to keep data
interpretation consistent, I limited our data usage to 2012 and afterwards. Even given that restriction,
we still have sufficient data to mine: approximately 53720 observations.

There were many empty cells in  raw data, as well as “unknown” and “NA” values; when we prepped
data in R, I replaced cells containing blank, NA or unknown values with the average values for that
column. There were also many numerical entries that corresponded to categories, and so many variables
were set to be factors to allow regression to run appropriately.

After prepping data, 135 variables were reduced to 98, which I classified into 9 categories: (1) GTD ID
and Date, (2) Incident Information, (3) Incident Location, (4) Attack Information, (5) Weapon Information,
(6) Target / Victim Information, (7) Perpetrator Information, (8) Casualties and Consequence, (9)
Additional Information and Sources.

Data Mining Tasks / Modeling

I. Visualization (See another repository for this)
(1) I used ggplot to create the histogram in the Appendix: Graph 1, where we see an increase in the
number of attacks globally between 1970 to 2015 overall, in terms of 9 different attack types. There is
also a breakdown of how each attack changed by year in the Appendix: Graph 2. (2) We created an
interactive world map zoomable to street view with points containing detailed attack information which
will be shown once being clicked. And attacks span from each decade between 1970 to 2015, see other repository.

Logistic Regression - Predicting Attack Success

Business Implications

In addition to understanding the casualties in an attack, we seek to understand what percent of attacks
were successful in inflicting harm and what factors are significant. As before, we used one nation to train
and another to test, this time comparing two European countries: Greece and the United Kingdom. Our
goal is to predict success of a terrorist attack given a set of historical variables.
Model
We used logistic regression to predict “success” of an attack, where “success” is a binary variable. Based
on intuition and using trial and error approach to find a good pair of robust regressors we found that “type
of attack” and “type of target,” and their interaction, gives highly significant coefficients. Our model seems
simple, but given the diversity of attack types and the interaction of those two variables, the results offer
depth.

Results

For example, when an attack was an armed assault chance of success was higher. When government
properties was targeted, chance of success was higher. An armed assault done against a government target
it was more successful than armed assault against other targets. We used a confusion matrix to compare
the accuracy of our model (See Matrix in Evaluation). I kept threshold as .5. If the probability was greater
than .5, it was likely for the event to occur.

Actual Value
Success = 1 Success = 0
Predicted Value Success = 1 TP = 229 FP = 95
Success = 0 FN = 25 TN = 44

Evaluation

To assess model for number of deaths in a terrorist attack, I compare the predictions of our model
to a base case of assuming that terrorist attacks will result in always result in the global mean of deaths
per attack, which is 2.18 people killed per attack. Aggregating the number of deaths our model predicts
and dividing by the number of attacks in Bangladesh yields a predicted average death rate of .33 persons
per attack. Since the actual death rate in Bangladesh is .25 persons killed per attack, our model proves to
be much more useful than making the simplest assumption.
For predicting the likelihood of successful attacks, we use the base case that all attacks are successful, as,
in the data, the large majority of terrorist attacks are classified as successful. Our predictive model has an
accuracy rate of 69.4%. The base case, assuming all attacks are successful, yields an accuracy rate of 64%.

Deployment

The findings and tools of my project will be used, primarily, to help smaller governments allocate
resources. In truth, the volume of terrorist attacks in Bangladesh is sufficient to train Bangladesh on
Bangladesh, but there are other countries with smaller populations and smaller incidents of terrorism that
should still be planning for the unfortunate inevitable.

My techniques are designed to provide proof of concept: that larger countries, with deeper datasets, can
be used as models for smaller countries where robust data may not be available. We will partner with
governments to selection nations with appropriately large datasets and otherwise similar characteristics to
use as training data. We will then use regression and data mining to identify significant factors in the
success and relative damage of terrorism. These techniques will allow for recommendations to
government clients on intervention and planning through the following, as examples: 1) a deeper
understanding of where, in terms of urbanicity, terrorism is likely to take place, 2) a deeper understanding
of the methods and types of terrorism most likely to succeed on their soil, 3) how many people are likely
to be killed in a given attack, as a proxy for the level of societal disruption likely to take place
As discussed earlier, each successful terrorist attack costs a nation, on average, $120,000 in damage and
loss. For smaller nations, especially, this can be catastrophic. Even if a small number of attacks can be
prevented through more efficient allocation of security forces, this can be significant. When an attack does
occur, having an appropriately sized trust fund in place to step in and replace losses will be important to
smaller nations; our work will provide the foundation for the creation of such funds.
