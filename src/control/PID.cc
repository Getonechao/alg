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
#include <cmath>
#include <math.h>

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
PID::PID(float kp, float ki, float kd, float max, float min, float T) {
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
 * @brief 矩形积分
 *
 * @param err
 * @param T
 * @return float
 */
float PID::RectangularIntegral_(float err, float T) {

  this->integral += err * T;
  return this->integral;
}

/**
 * @brief 梯形积分
 *
 * @param err
 * @param T
 * @return float
 */
float PID::TrapezoidalIntegrals_(float err, float T) {
  this->integral += (err + err_last) / 2 * T;
  return this->integral;
}

/**
 * @brief pid控制器
 *
 * @param setpoint 设定值
 * @param pv 反馈值
 * @epslion 积分分离参数
 * @return float
 */
float PID::pid_control(float setpoint, float pv) {
  // 1.误差
  err = setpoint - pv;
  float kp_ = kp;
  float ki_ = ki;
  float kd_ = kd;

  // 2.积分分离
  if (fabs((err) / setpoint) > epslion) {
    ki_ = ki;
  } else {
    ki_ = 0;
  }

  // 3.PID core
  output = kp_ * err + ki_ * RectangularIntegral_(err, T) +
           kd_ * (err - err_last) / T;
  err_last = err;

  // 4.抗积分饱和
  if (output > max) {
    output = max;
  } else if (output < min) {
    output = min;
  }
  return output;
}

/**
 * @brief Construct a new Changing Intergration PID:: Changing Intergration PID
 * object
 *
 * @param kp
 * @param ki
 * @param kd
 * @param max
 * @param min
 * @param T
 */
ChangingIntergrationRatePID::ChangingIntergrationRatePID(float kp, float ki,
                                                         float kd, float max,
                                                         float min, float T)
    : PID(kp, ki, kd, max, min, T) {
  this->err_last = 0;
}

/**
 * @brief ChangingIntergrationRatePID控制器
 *
 * @param setpoint
 * @param pv
 * @param epslion
 * @return float
 */
float ChangingIntergrationRatePID::pid_control(float setpoint, float pv) {
  // 1.误差
  err = setpoint - pv;
  float kp_ = kp;
  float ki_ = ki;
  float kd_ = kd;

  // 2.变速积分
  integral += Intergration(setpoint, pv) * T;

  // 3.PID core
  output = kp_ * err + ki_ * integral + kd_ * (err - err_last) / T;
  err_last = err;

  // 4.抗积分饱和
  if (output > max) {
    output = max;
  } else if (output < min) {
    output = min;
  }
  return output;
}
/**
 * @brief 变速积分速率
 * 
 * @param relativeErr 相对误差
 * @return float 
 */
float ChangingIntergrationRatePID::IntergrationRate(float relativeErr) {
  float rate;
  if (fabs(relativeErr) <= integral_B) {
    rate = 1;
  } else if (fabs(relativeErr) >= (integral_A + integral_B)) {
    rate = 0;
  } else {
    rate = (integral_A + integral_B - fabs(relativeErr)) / (integral_A);
  }
  return rate;
}

float ChangingIntergrationRatePID::Intergration(float setpoint, float pv) {

  return IntergrationRate(fabs((setpoint - pv) / setpoint)) * (setpoint - pv);
}




