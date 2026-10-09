use std::time::Duration;

#[derive(Debug, Default)]
pub struct ExecuteAccumulateTime {
    total: Duration,
}

impl ExecuteAccumulateTime {
    pub fn execute_accumulate_time<F, T>(&mut self, f: F) -> T
    where
        F: FnOnce() -> T,
    {
        let start_time = std::time::Instant::now();
        let result = f();
        let duration = start_time.elapsed();
        self.total += duration;
        result
    }

    pub fn total(&self) -> Duration {
        self.total
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use all_asserts::assert_true;

    #[test]
    fn test_execute_accumulate_time_times_correctly() {
        let mut timer = ExecuteAccumulateTime::default();
        let sleep_duration = std::time::Duration::from_millis(10);

        timer.execute_accumulate_time(|| {
            std::thread::sleep(sleep_duration);
        });

        assert_true!(timer.total() >= sleep_duration);
    }

    #[test]
    fn test_execute_accumulate_time_accumulates_correctly() {
        let mut timer = ExecuteAccumulateTime::default();
        let repetitions = 5;
        let sleep_duration = std::time::Duration::from_millis(10);
        for _ in 0..repetitions {
            timer.execute_accumulate_time(|| {
                std::thread::sleep(sleep_duration);
            });
        }

        assert_true!(timer.total() >= sleep_duration * repetitions);
    }
}
