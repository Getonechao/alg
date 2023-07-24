#include "filter.hh"
#include <cmath>



/**
 * @brief 加权递归平均滤波器
 * 
 * @param input 
 * @param weight 
 * @return float 
 */
float MeanFilter::WeightedRecursiveAverageFilter(float input, std::vector<float> weight)
{

  if (weight.size() != windowSize) {std::cerr<<"weight size error";exit(-1);}
  
  
  
  if(count == 0)
  {
    for (int i=0; i<windowSize-2; i++) {
      windows.push_back(input);
    }
  }
  if(count < windowSize){count++;}
  

  windows.push_back(input);
  windows.pop_front();
  float sum = 0;
  
  for (int i = 0; i < windowSize; i++) 
  {
    sum = sum + windows[i] * weight[i];
  }
  filter_output = sum;
  return filter_output;
}



/**
 * @brief 限幅平均滤波器
 * 
 * @param input 
 * @param threshold 
 * @return float 
 */
float MeanFilter::ClippingAverageFilter(float input, float threshold)
{
  //初始化
  if(count == 0)
  {
    for (int i=0; i<windowSize-2; i++) {
      windows.push_back(input);
    }
  }
  if(count < windowSize){count++;}

  //限幅
  if(fabs(input - windows[windowSize-2]) > threshold)
  {
     windows.push_back(windows[windowSize-2]);
  }else {
    windows.push_back(input);
  }

  //滑动平均滤波法
  windows.pop_front();
  float sum = 0;
  for (int i = 0; i < windowSize; i++) 
  {
    sum = sum + windows[i];
  }
  filter_output = sum / windowSize;
  return filter_output;
}

/**
 * @brief 中值平均滤波器
 * 
 * @return float 
 */
float MeanFilter::MedianAveragingFilter(float input)
{
  return 0;
} 






