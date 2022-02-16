# Scenario

Elpen Pharmaceuticals has recently announced the launch of a new product called Platorel into the “Lipid modifying agents” market (disease area) in Greece and they want to run a project to analyze its performance.

They are looking for a vendor to build a performance dashboard for their brand Platorel. Therefore, asked us for two points:

1.	to conduct a small Proof of Concept (PoC) on a subset of data to demonstrate our approach and capabilities on data management and visualization and our ability in the business understanding and generation of business insights;

2.	to explain the project approach for the full project.

As a new hire in the Business Intelligence department, your first job is to go through the data, check/transform them appropriately and then create a dashboard with some meaningful insights and demo it to the client.


# Assumptions

•	Data is not fully validated by the production department. There can be something missing or wrong.

•	The client’s requirement for the PoC is to have the analysis at brand level and the possibility to aggregate numbers at Year -> Quarter -> Month granularity.

They would also like to see some important metrics that could be derived and that can show the dynamics of the market, for example the sales value (pay attention, values not UNITS), the market share and the Evolution Index (see tips below). In addition, they are of course interested in discovering the result of the launch.

•	Visuals do not have to be perfect given the time constraints. Focusing on data management and approach is more important.

•	Any tool can be used to achieve your goal (e.g. SQL, R, Excel, Power BI, Tableau, Qlik Sense, etc.). Select the ones you feel most familiar with.


# PoC Objectives

1)	Look at the files provided to understand their contents and logical relationships at high level.

2)	Check the datasets in order to identify potential problems with data quality (for example entity and domain integrity, etc.). See also tips below.

3)	Think and define your data mart. Transform the data if necessary, connect the files in Excel in order to create a fact that contains all the information or import the tables into a BI tool and make the table connections there. 

4)	Play with the data, create some visuals that can satisfy the client’s needs, identify some meaningful insights.

5)	Present the results in a way Elpen will understand your approach and be convinced by your results.


# Project approach

Of course, the project will have a higher level of complexity, with more data sources, more dimensions to be managed and more requests from the client.

Thinking about this, please suggest:

a)	How you would run the workshop to define and agreed the requirements with the client?
•	How would you structure the workshop in general?
•	What are the specific questions you would ask after having done the PoC?
 
b)	What would be the ideal architectural scenario and components you would setup and why? What technologies? 

c)	A possible team by specifying what kind of roles are needed to handle this kind of project. For each role give also a list of main responsibilities.

d)	What phases would your project plan have and what would be the main activities for each of the phase.


# PoC Tips

The Market definition is a group of products used in the same area as the client’s product. Hence will be direct competitors of the client’s product when it will be launched. 
The goal of the market definition is to identify products that are sufficiently close substitutes in demand, so that you can measure the performance of client product compared to others.

Sometimes data quality issues can be better identified during the definition of the data mart and the creation of the visuals (objective 3 and 4).

Regarding the launch, to identify the competing products of Platorel, look at the molecule. 

The Market share represents the % ratio of a product Sales to the total market sales (sales of client product plus all the competitor product in the same disease area). The formula is: (Product / Total Market *100).

The Evolution Index represent the Product growth vs Market Growth. The formula is: ((100 + Product Growth%) / (100 + Market Growth%)) x 100.
