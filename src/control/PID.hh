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
class PID{
  public:
    float kp,ki,kd,T;
    float err,err_last;
    float integral;
    float output;
    float max,min;
    explicit PID(float kp,float ki,float kd,float max,float min,float T);
    virtual ~PID(){};
    virtual float pid_control(float setpoint,float pv,float epslion);

  protected:
    float RectangularIntegral_(float err,float T);
    float TrapezoidalIntegrals_(float err,float T);
};


/**
 * @brief 变速PID控制器
 * 
 */
class ChangingIntergrationPID:public PID{
  public:
    float err_last2;
    explicit ChangingIntergrationPID(float kp,float ki,float kd,float max,float min,float T);
    virtual ~ChangingIntergrationPID(){};
    virtual float pid_control(float setpoint,float pv,float epslion);
};



