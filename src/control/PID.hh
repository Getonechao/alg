/**
 * @file PID.hh
 * @author zhangchao (1509670272@qq.com)
 * @brief 
 * @version 0.1
 * @date 2023-07-23
 * 
 * @copyright Copyright (c) 2023
 * 
 */
#pragma once






/**
 * @brief PID控制器
 * 
 */
#include <cmath>
#include <limits>
class PID{
  public:
    float kp,ki,kd,T;
    float err,err_last;
    float integral;
    float epslion;
    float output;
    float max,min;
    explicit PID(float kp,float ki,float kd,float max,float min,float T);
    virtual ~PID(){};
    virtual float pid_control(float setpoint,float pv);
    
    inline void setParam(float epslion)
    { 
      this->epslion = epslion;
    }

  protected:
    float RectangularIntegral_(float err,float T);
    float TrapezoidalIntegrals_(float err,float T);
};





/**
 * @brief 变速PID控制器
 * 
 */
class ChangingIntergrationRatePID:public PID{
  
  public:
    float  err,err_last;
    explicit ChangingIntergrationRatePID(float kp,float ki,float kd,float max,float min,float T);
    virtual ~ChangingIntergrationRatePID(){};
    
    virtual float pid_control(float setpoint,float pv);
    

    /**
     * @brief Set the Function Param object
     * 
     * @param integral_A 相对误差大于A+B时，rate=0
     * @param integral_B 相对误差小于B时，rate=1
     */
    inline void setIntergrationRateParam(float integral_A,float integral_B)
    { 
      this->integral_A = integral_A;
      this->integral_B = integral_B;
    }

  private:
    float integral_A,integral_B;
    float IntergrationRate(float relativeErr);
    float Intergration( float setpoint,float pv);
};


class LowPassFilterPID:public PID{
  public:
    float  err,err_last;
    float  lpfilter,lpfilter_last,fc;


    explicit LowPassFilterPID(float kp,float ki,float kd,float max,float min,float T);
    virtual ~LowPassFilterPID(){};
    virtual float pid_control(float setpoint,float pv);


  private:
  
  /**
   * @brief 一阶低通滤波器
   * 
   * @param err
   * @param err_last
   * @param fc 截止频率
   * @param T 采样周期
   * @return float 
   */
    inline float LowPassFilter(float err, float fc, float T)
    {
      float alpha = T/(T+ 1/2*M_PI*fc);
      return alpha*err+(1-alpha)*lpfilter_last;
    }
      
};




