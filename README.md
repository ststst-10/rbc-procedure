<h3>Requirements:</h3>
  
All the files have been created and run on Matlab R2025b with Dynare version 6.5, on Windows 11.<br>
Matlab must be installed (instructions at https://it.mathworks.com/products/matlab.html). Matlab online should be fine.<br>
Dynare must be installed (instructions at https://www.dynare.org/).<br>
Installation of other specific Matlab packages may be required (e.g. Matlab econometrics toolbox).<br>

The package contains all the necessary functions and dataset to run the RBC.mod and RBC_procedure.mlx files.<br>
In case one wants to download recent versions of the datasets, later on, there should be no problem: datasets from Fred should be downloaded as .xlsx excel files, and the name of the file should follow the format, "ID.xlsx", with ID being the ID of the dataset (e.g. PCND for Personal Consumption Expenditures: Nondurable Goods).<br> 
Please note that, in downloading a new version of Population Level (CNP16OV), one must remember to directly adjust the series to quartery, average aggregated, frequency directly on FRED.<br> 

For reference the datasets are:  
- Population Level (CNP16OV) {https://fred.stlouisfed.org/series/CNP16OV}<br>
- Gross Domestic Product (GDP) {https://fred.stlouisfed.org/series/GDP}<br>
- Gross Domestic Product: Implicit Price Deflator (GDPDEF) {https://fred.stlouisfed.org/series/GDPDEF}  
- Personal Consumption Expenditures: Durable Goods (PCDG) {https://fred.stlouisfed.org/series/PCDG}  
- Personal Consumption Expenditures: Nondurable Goods (PCND) {https://fred.stlouisfed.org/series/PCND}  
- Personal Consumption Expenditures: Services (PCESV) {https://fred.stlouisfed.org/series/PCESV}   
- Nonfarm Business Sector: Hours Worked for All Workers (HOANBS) {https://fred.stlouisfed.org/series/HOANBS}  
- Total Factor Productivity (DTFP) and Total Factor Productivity Utilization Adjusted (DTFP_UTIL) {https://www.frbsf.org/research-and-insights/data-and-indicators/total-factor-productivity-tfp/}  

<h3>Replication:</h3>

All material in this repository should be downloaded and put into a folder.<br>
The folder should be initialised as the standard path in Matlab (Set path > Add folder > Add folder to path).<br>  
The full procedure is performed by running only one file: RBC_procedure.mlx.<br>   
The output will be displayed both inside the file (under the code blocks) and as external products:
- 4 .tex tables, recognisable by the prefix "y_"<br>
- 4 .png figures, recognisable by prefix "z_"<br>
- Auxiliary files: RBC.log and the folders RBC and RBC+, which are necessary outputs for Dynare functioning.<br>
