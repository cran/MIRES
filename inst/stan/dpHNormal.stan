functions {
  vector break_that_stick(vector stick_slices) {
    int K = num_elements(stick_slices) + 1;
    vector[K] pi;
    pi[1] = stick_slices[1];
    for(k in 2:(K - 1)) {
      pi[k] = stick_slices[k] * prod(1 - stick_slices[1:(k - 1)]);
    }
    // pi[k] = 1 - sum(pi[1:(K - 1)]);
    pi[K] = prod(1 - stick_slices[1:(K - 1)]);

    return(pi);
  }
}

data {
  int N; // Number of values for DP density estimation
  int K; // Maximum number of DP clusters
  vector[N] y; // Data
}

transformed data {
  
}

parameters {
  // DP params
  real<lower = 0> alpha; // Dirichlet-beta prior value.
  vector<lower = 0, upper = 1>[K - 1] stick_slices;

  // Cluster params
  vector<lower=0>[K] location; 
  vector<lower=0>[K] scale;
}

transformed parameters {
  vector<lower = 0, upper = 1>[K] pi = sort_desc(break_that_stick(stick_slices));
  
}

model {
  /* real sigma = 1.0; // Just use a N(mu, 1) for DP components for now. */
  vector[K] log_pi = log(pi);

  // Priors
  location ~ normal(0, 3);
  /* scale ~ normal(0, 2); */
  scale ~ exponential(5);

  alpha ~ gamma(2, 2);
  stick_slices ~ beta(1, alpha);

  // Model
  /*
    p(y|...) = sum_k pi_k p(y | theta_k)
    log(p(y|...)) = log(sum_k pi_k p(y | theta_k))
                  = log(sum_k exp(log(pi_k) + log_p(y | theta_k)))
   */ 
  for(n in 1:N) {
    vector[K] lp_y = log_pi;
    for(k in 1:K) {
      lp_y[k] += normal_lpdf(y[n] | location[k], scale[k]) - normal_lccdf(0 | location[k], scale[k]);
    }
    target += log_sum_exp(lp_y);
  }
  
}

generated quantities {
  // Density at zero.
  real py_0;
  {
    vector[K] log_pi = log(pi);
    vector[K] lp_y0 = log_pi;
    for(k in 1:K) {
      lp_y0[k] += normal_lpdf(0.0 | location[k], scale[k]) - normal_lccdf(0 | location[k], scale[k]);
    }
    py_0 = sum(exp(lp_y0));
  }
  
}
