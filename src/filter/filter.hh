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
class FilterBase
{
  protected:
    float T;
    float filter_output;
};


class MovingAverageFilter:public FilterBase
{
  public:
    MovingAverageFilter(float T,int N)
    {
      this->T=T;
      this->N=N;
      this->count=0;
      deque.resize(N);
    }

    virtual ~MovingAverageFilter(){};
   
    inline float filter(float input)
    {
      deque.push_back(input);
      deque.pop_front();
      float sum=0;
      
      for(auto &i:deque)
      {
        sum+=i;
      }

      filter_output=sum/deque.size();
      return filter_output;
    }

  private:
    float filter_output;
    float T,N,count;
    std::deque<float> deque;
};






