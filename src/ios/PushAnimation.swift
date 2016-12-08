//
//  PushAnimation.swift
//  HelloCordova
//
//  实现代码来自
//  http://joeytat.com/post/ios/5.-ru-he-rang-push
//
//

import UIKit

class PushAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        // 获取被 present 的 view controller
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        // 设置 toViewController 的动画初始状态
        // x轴坐标在屏幕最右边
        let containerView = transitionContext.containerView
        let bounds = UIScreen.main.bounds
      toViewController.view.frame = CGRect(x: bounds.width, y: finalFrame.origin.y, width: finalFrame.width, height: finalFrame.height)
        //将 toViewController 添加到容器视图中
        containerView.addSubview(toViewController.view)
      
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.3, options: .curveEaseIn, animations: {
          () -> Void in
             fromViewController.view.frame=CGRect(x: bounds.width*0.3*(-1), y: finalFrame.origin.y, width: finalFrame.width, height: finalFrame.height)
            fromViewController.view.alpha = 0.7
            toViewController.view.frame = finalFrame
            }, completion: {
               
                
                //告知 transitionContext 动画完成
                finished in
                fromViewController.view.alpha = 1

                transitionContext.completeTransition(true)
               
             
                
        })
    }
}
class PopAnimation: NSObject , UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        // 获取被 present 的 view controller
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        // 设置 toViewController 的动画初始状态
        // x轴坐标在屏幕最右边
        let containerView = transitionContext.containerView
        let bounds = UIScreen.main.bounds
        toViewController.view.frame = CGRect(x: bounds.width*(-1), y: 0, width: finalFrame.width, height: finalFrame.height)
        //将 toViewController 添加到容器视图中
        containerView.addSubview(toViewController.view)
         toViewController.view.alpha = 0.3
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.3, options: .curveEaseIn, animations: {
            () -> Void in
                fromViewController.view.frame=CGRect(x: bounds.width*0.2*(-1), y: finalFrame.origin.y, width: finalFrame.width, height: finalFrame.height)
            toViewController.view.alpha = 1
            toViewController.view.frame = finalFrame
            }, completion: {
                
                
                //告知 transitionContext 动画完成
                finished in
            
                
                transitionContext.completeTransition(true)
                
                
                
        })
    }
}
