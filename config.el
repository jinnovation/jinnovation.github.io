(setq op/repository-directory (expand-file-name ".")
      op/category-ignore-list '("themes" "blog" "img")
      op/theme-root-directory (expand-file-name "./themes")
      ;; TODO: https
      op/site-domain "http://jjin.info"
      op/personal-github-link nil
      op/site-main-title "Jonathan Jin"
      op/site-sub-title ""
      op/personal-avatar "/headshot.jpg"
      op/personal-google-analytics-id "UA-42551205-2")

(defun op/jjin-default-navigation-categories ()
  (ht-merge (ht ("site-main-title" op/site-main-title)
                ("site-sub-title" op/site-sub-title)
                ("nav-categories"
                 (mapcar
                  #'(lambda (cat)
                      (ht ("category-uri"
                           (concat "/" (encode-string-to-url cat) "/"))
                          ("category-name" (op/get-category-name cat))))
                  (sort (cl-remove-if
                         #'(lambda (cat)
                             (or (string= cat "index")
                                 (string= cat "about")
                                 (member cat op/category-ignore-list)))
                         (op/get-file-category nil))
                        'string-lessp)))
                ("search" nil)
                ("avatar" op/personal-avatar)
                ("site-domain" (if (string-match
                                    "\\`https?://\\(.*[a-zA-Z]\\)/?\\'"
                                    op/site-domain)
                                   (match-string 1 op/site-domain)
                                 op/site-domain)))
            (if op/organization (ht ("authors-li" t)) (ht ("avatar" op/personal-avatar)))))

(advice-add
 'op/render-navigation-bar :filter-args
 (lambda (&optional param-table)
   "Overrides the parameter table with my own defaults."
   (list (ht-merge
          (op/jjin-default-navigation-categories)
          (ht
           ("static-pages"
            (cons
             (ht ("static-uri" "/resume.pdf") ("static-title" "Resume"))
             (mapcar
              (lambda (org-file)
                (ht ("static-uri" (concat "/" (file-name-sans-extension org-file)))
                    ("static-title" (capitalize (file-name-sans-extension org-file)))))
              (remove-if (lambda (file)
                           (or
                            (not (string= (file-name-extension file) "org"))
                            (string= (file-name-nondirectory file) "index.org")))
                         (directory-files op/repository-directory))))))))))

;; Don't use /about, default or otherwise.
(defalias 'op/generate-about 'ignore)
(fset 'op/default-update-category-index 'op/update-category-index)
(defalias 'op/update-category-index 'ignore)

;; disable comments and meta, globally
(setq op/category-config-alist
      (mapcar (lambda (list)
                (let ((category (car list))
                      (config (cdr list)))
                  (cons category
                        (plist-put (plist-put config :show-comment nil) :show-meta nil))))
              op/category-config-alist))

(provide 'config)
