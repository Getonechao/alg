/**
 * @file filter.hh
 * @author zhangchao (1509670272@qq.com)
 * @brief
 * @version 0.1
 * @date 2023-07-24
 *
 * @copyright Copyright (c) 2023
 *
 */
#pragma once

/**
 * @brief 滤波器
 *
 */
#include <deque>
#include <vector>
#include <iostream>
class FilterBase {
protected:
  float T;
  float filter_output;
};

/**
 * @brief 滑动均值滤波器
 * 
 */
class MeanFilter : public FilterBase {
private:
  //滤波输出
  float filter_output;
  //采样周期 滑动窗口大小
  float T, windowSize, count;
  //滑动窗口
  std::deque<float> windows;
  //权重
  std::vector<float> weight;
  //
  float last_output;


public:
  MeanFilter(float T, int windowSize) {
    this->T = T;
    this->windowSize = windowSize;
    this->count = 0;
    windows.resize(windowSize);
    
    weight.resize(windowSize);
    for (int i = 0; i < windowSize; i++) {
      weight[i] = 1.0 / windowSize;
    }
  }

  virtual ~MeanFilter(){};
  
  //加权递归平均滤波器 
  float WeightedRecursiveAverageFilter(float input, std::vector<float> weight); 
  //限幅平均滤波器
  float ClippingAverageFilter(float input, float threshold);
  //中值平均滤波器(防脉冲干扰平均滤波器)
  float MedianAverageFilter(float input);

 
};



