/**
 * @file PID.cc
 * @author zhangchao (1509670272@qq.com)
 * @brief 
 * @version 0.1
 * @date 2023-07-23
 * 
 * @copyright Copyright (c) 2023
 * 
 */
#include <PID.hh>


 /**
  * @brief Construct a new PID::PID object
  * 
  * @param kp 比例增益系数
  * @param ki 积分增益系数
  * @param kd 微分增益系数
  * @param max 
  * @param min 
  * @param T 采样周期 
  */
PID::PID(float kp,float ki,float kd,float max,float min,float T ){
  this->kp = kp;
  this->ki = ki;
  this->kd = kd;
  this->T = T;
  
  // 抗积分饱和
  this->max = max;
  this->min = min;

  this->err_last = 0;
  this->integral = 0;
}

/**
 * @brief pid控制器
 * 
 * @param setpoint 
 * @param pv 
 * @return float 
 */
float PID::pid_control(float setpoint,float pv,float epslion=1000000){
  //1.误差
  err = setpoint - pv;

  float kp_=kp;
  float ki_=ki;
  float kd_=kd;

  //2.积分分离
  if(err>epslion)
  {
    ki_=0; 
  }

  //3.PID core
  output = kp_*err + ki_*RectangularIntegral_(err,T)+ kd_*(err - err_last)/T;
  err_last = err;

  //4.抗积分饱和
  if(output > max){
    output = max;
  }else if(output < min){
    output = min;
  }
  return output;
}

/**
 * @brief 矩形积分
 * 
 * @param err 
 * @param T 
 * @return float 
 */
float PID::RectangularIntegral_(float err,float T){
  
  this->integral += err*T;
  return this->integral;
}

/**
 * @brief 梯形积分
 * 
 * @param err 
 * @param T 
 * @return float 
 */
float PID::TrapezoidalIntegrals_(float err,float T){
  this->integral += (err + err_last)/2*T;
  return this->integral;
}


