type R = boolean;
type Unpack<T> = T extends (infer R)[] ? R : R;
