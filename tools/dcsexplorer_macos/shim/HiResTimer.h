#pragma once
#include <chrono>
#include <thread>
class HiResTimer {
public:
	double GetTime_seconds() const { return std::chrono::duration<double>(std::chrono::steady_clock::now().time_since_epoch()).count(); }
	void SleepFor(double s) { std::this_thread::sleep_for(std::chrono::duration<double>(s)); }
	void SleepUntil(double t) { double d = t - GetTime_seconds(); if (d > 0) SleepFor(d); }
};
