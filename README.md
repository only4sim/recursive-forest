Certainly! Here's a detailed README for the "Recursive Forest -- Compress 10000 XGBoost Decision Tree to 1" project:

---

# Recursive Forest -- Compress 10000 XGBoost Decision Tree to 1

## Introduction

### Project Overview
The Recursive Forest project aims to revolutionize the way we handle large-scale machine learning models by compressing a forest of 10,000 XGBoost decision trees into a single, optimized tree using recursive zero-knowledge proof techniques and verifier generalization. Leveraging the Mina protocol and Neon EVM, this project addresses the complexities traditionally associated with large forest models.

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
- Neon EVM
- Other relevant data processing and machine learning libraries

## File structure
The main folder contains `xgboost2recursive`, `evm_verifier` and Mina zk-program. The `xgboost2recursive` includes all the code to train, extract model, and input data - model parameter alignment extraction. If you want to use the model extraction, please check `plot_model.ipynb`. Otherwise, `main.sh` is always a great place to start with. Please create four folder before the training: `code`, `models`, `input`, `output`, `processed`. Put all the codes into `code` folder and the input data (only csv file) downloaded from Kaggle into the `input` folder. Then run
```
cd code 
./main.sh
```
You can find the model in the `models` folder and results in the `output` folder.
It may take 10 hours for trainning.

If you want to prune the number of trees, you can try `make_predictions_prune.py`.

The example of EVM verifier can be found in the `evm_verifier`. The verifier is written with ZoKrates and has alrealy been extended to the full binary decision tree.

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

