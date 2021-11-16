#!/usr/bin/env python
# coding: utf-8

# In[4]:


import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import matplotlib
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8)

pd.options.mode.chained_assignment = None



# Now we need to read in the data

df = pd.read_csv(r'C:\Users\ashra\Downloads\movies.csv')


# In[6]:


# Now let's take a look at the data

df.head()


# In[7]:


# We need to see if we have any missing data
# Let's loop through the data and see if there is anything missing

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, round(pct_missing*100)))


# In[11]:


new_df = df.fillna ({'rating' : 'not rated',
                     'budget' : 0,
                     'gross' : 0
                    })


# In[12]:


new_df


# In[13]:


# Data Types for our columns

print(new_df.dtypes)


# In[15]:


#change data types of columns

new_df['budget'] = new_df['budget'].astype('int64')
new_df['gross'] = new_df['gross'].astype('int64')


# In[43]:


#Droop any duplicates

df.drop_duplicates()


# In[24]:


# Are there any Outliers?

new_df.boxplot(column=['gross'])


# In[32]:


#Plot budget vs gross using seaborn

sns.regplot(x='gross', y='budget', data=new_df, scatter_kws={"color" : "black"}, line_kws={"color" : "blue"})


# In[29]:


#Plot score vs gross using seaborn

sns.regplot(x="score", y="gross", data=new_df, scatter_kws={"color" : "red"}, line_kws={"color" : "blue"})


# In[33]:


# Correlation Matrix between all numeric columns

new_df.corr(method ='pearson')


# In[34]:


new_df.corr(method ='kendall')


# In[35]:


new_df.corr(method ='spearman')


# In[36]:


correlation_matrix = new_df.corr()

sns.heatmap(correlation_matrix, annot = True)

plt.title("Correlation matrix for Numeric Features")

plt.xlabel("Movie features")

plt.ylabel("Movie features")

plt.show()


# In[44]:


# Using factorize - this assigns a random numeric value for each unique categorical value

new_df.apply(lambda x: x.factorize()[0]).corr(method='pearson')


# In[45]:


correlation_matrix = new_df.apply(lambda x: x.factorize()[0]).corr(method='pearson')

sns.heatmap(correlation_matrix, annot = True)

plt.title("Correlation matrix for Movies")

plt.xlabel("Movie features")

plt.ylabel("Movie features")

plt.show()


# In[60]:


correlation_mat = new_df.apply(lambda x: x.factorize()[0]).corr()

corr_pairs = correlation_mat.unstack()

print(corr_pairs.head())


# In[61]:


sorted_pairs = corr_pairs.sort_values(kind="quicksort")

print(sorted_pairs.head())


# In[48]:


# We can now take a look at the ones that have a high correlation (> 0.5)

strong_pairs = sorted_pairs[abs(sorted_pairs) > 0.5]

print(strong_pairs)


# In[51]:


# Looking at the top 15 compaies by gross revenue

CompanyGrossSum = new_df.groupby('company')[["gross"]].sum()

CompanyGrossSumSorted = CompanyGrossSum.sort_values('gross', ascending = False)[:15]

CompanyGrossSumSorted = CompanyGrossSumSorted['gross'].astype('int64') 

CompanyGrossSumSorted


# In[52]:


new_df['Year'] = new_df['released'].astype(str).str[:4]


# In[59]:


CompanyGrossSum = new_df.groupby(['company', 'year'])[["gross"]].sum()

CompanyGrossSumSorted = CompanyGrossSum.sort_values(['gross','company','year'], ascending = False)[:15]

CompanyGrossSumSorted = CompanyGrossSumSorted['gross'].astype('int64') 

CompanyGrossSumSorted


# In[ ]:




