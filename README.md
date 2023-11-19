Certainly! Here's a detailed README for the "Recursive Forest -- Compress 10000 XGBoost Decision Tree to 1" project:

---

# Recursive Forest -- Compress 10000 XGBoost Decision Tree to 1

## Introduction

### Project Overview
The Recursive Forest project aims to revolutionize the way we handle large-scale machine learning models by compressing a forest of 10,000 XGBoost decision trees into a single, optimized tree using recursive zero-knowledge proof techniques. Leveraging the Mina protocol, this project addresses the complexities traditionally associated with large decision tree models.

### Background
Utilizing real polarized radar data from the "How Much Did It Rain?" competition on Kaggle, the project taps into the rich datasets of NEXRAD and MADIS. The approach is rooted in practical, real-world data challenges and aims to offer a scalable solution in data-intensive domains.

## Project Details

### Data and Model
The project processed over a million training samples and more than 600,000 testing samples. Initially, the model comprised over 50,000 decision trees, posing significant challenges in terms of computational resources and efficiency.

### Recursive Zero-Knowledge Proof Technique
This technique involves compressing the proof of XGBoost's decision trees into an iterative recursion over a tree proof. The method significantly simplifies the complexity of the circuit, making it more manageable and efficient.

### Challenges and Solutions
- **Model Optimization and Compression**: 
  The project successfully compresses the number of decision trees to 900, with a negligible accuracy loss (less than 0.00002), ensuring optimized model complexity without compromising performance.
- **Parameter Complementation and Alignment**: 
  A novel scheme was introduced to align decision tree parameters, allowing diverse trees to be handled by a single circuit file, thus reducing the overhead of generating multiple circuit layouts.

## Implementation

### Required Tools and Libraries
- Python
- XGBoost
- Mina Protocol
- Other relevant data processing and machine learning libraries


## How to build

```sh
npm run build
```

## How to run
```sh
node build/src/main.js
```

## Acknowledgments
- Credits to data providers, contributors, and any other party whose support was instrumental in the project's development.

## License

[Apache-2.0](LICENSE)

